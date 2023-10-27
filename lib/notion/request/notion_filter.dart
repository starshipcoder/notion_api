import 'package:notion_api/notion/general/properties/database_property.dart';
import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/utils/utils.dart';

enum LogicOperator { and, or }

enum TextFilterField {
  contains,
  doesNotContain,
  doesNotEqual,
  endsWith,
  equals,
  isEmpty,
  isNotEmpty,
  startsWith,
}

extension TextFilterTypeExtension on TextFilterField {
  String get toJsonName {
    switch (this) {
      case TextFilterField.contains:
        return 'contains';
      case TextFilterField.doesNotContain:
        return 'does_not_contain';
      case TextFilterField.doesNotEqual:
        return 'does_not_equal';
      case TextFilterField.endsWith:
        return 'ends_with';
      case TextFilterField.equals:
        return 'equals';
      case TextFilterField.isEmpty:
        return 'is_empty';
      case TextFilterField.isNotEmpty:
        return 'is_not_empty';
      case TextFilterField.startsWith:
        return 'starts_with';
      default:
        return 'unknown';
    }
  }
}

class DatabaseFilter {
  const DatabaseFilter(this.filters, [this.operator = LogicOperator.and]);

  final List<PropertyFilter> filters;
  final LogicOperator operator;

  Map<String, dynamic> toJson() {
    List<PropertyFilter> validFilters = this.filters.where((element) => element.isValid()).toList();

    if (validFilters.isEmpty) return {};
    if (validFilters.length == 1) return filters.first.toJson();
    return {
      '${operator.name}': validFilters.map((filter) => filter.toJson()).toList(),
    };
  }

  bool isValid() {
    return filters.any((element) => element.isValid());
  }

  DatabaseFilter copyWith({List<PropertyFilter>? filters, LogicOperator? operator}) {
    return DatabaseFilter(
      filters ?? this.filters,
      operator ?? this.operator,
    );
  }

  @override
  String toString() {
    return 'DatabaseFilter{filters: $filters, operator: $operator}';
  }
}

abstract class PropertyFilter {
  final String propName;
  final PropertyType type;

  PropertyFilter({required this.propName, required this.type});

  Map<String, dynamic> toJson();

  bool isValid();

  PropertyFilter generalCopyWith({String? propName, PropertyType? type});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PropertyFilter && runtimeType == other.runtimeType && propName == other.propName &&
              type == other.type;

  @override
  int get hashCode => propName.hashCode ^ type.hashCode;


}

class CheckboxFilter extends PropertyFilter {
  final bool value;

  CheckboxFilter({required super.propName, required this.value}) : super(type: PropertyType.Checkbox);

  Map<String, dynamic> toJson() {
    return {
      'property': '$propName',
      'checkbox': {
        'equals': value,
      }
    };
  }

  @override
  String toString() {
    return 'CheckboxFilter{propName: $propName, value: $value}';
  }

  @override
  PropertyFilter generalCopyWith({String? propName, PropertyType? type}) {
    return copyWith(propName: propName);
  }

  CheckboxFilter copyWith({bool? value, String? propName}) {
    return CheckboxFilter(propName: propName ?? this.propName, value: value ?? this.value);
  }

  @override
  bool isValid() => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other && other is CheckboxFilter && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => super.hashCode ^ value.hashCode;


}

class TextFilter extends PropertyFilter {
  final TextFilterField filterField;
  final String? query;

  TextFilter({this.query, required super.propName, required this.filterField, required super.type});

  Map<String, dynamic> toJson() {
    switch (filterField) {
      case TextFilterField.contains:
      case TextFilterField.doesNotContain:
      case TextFilterField.doesNotEqual:
      case TextFilterField.endsWith:
      case TextFilterField.equals:
      case TextFilterField.startsWith:
        return {
          'property': '$propName',
          '${type.toJsonName}': {
            '${filterField.toJsonName}': '$query',
          }
        };
      case TextFilterField.isEmpty:
      case TextFilterField.isNotEmpty:
        return {
          'property': '$propName',
          '${type.toJsonName}': {
            '${filterField.toJsonName}': true,
          }
        };
    }
  }

  @override
  String toString() {
    return 'TextFilter{filterType: $filterField, query: $query}';
  }

  @override
  PropertyFilter generalCopyWith({String? propName, PropertyType? type}) {
    return copyWith(propName: propName, type: type);
  }

  TextFilter copyWith({String? propName, PropertyType? type, TextFilterField? filterField, String? query}) {
    return TextFilter(
      type: type ?? this.type,
      propName: propName ?? this.propName,
      filterField: filterField ?? this.filterField,
      query: query ?? this.query,
    );
  }

  @override
  bool isValid() {
    switch (filterField) {
      case TextFilterField.contains:
      case TextFilterField.doesNotContain:
      case TextFilterField.doesNotEqual:
      case TextFilterField.endsWith:
      case TextFilterField.equals:
      case TextFilterField.startsWith:
        return query != null && query!.isNotEmpty;
      case TextFilterField.isEmpty:
      case TextFilterField.isNotEmpty:
        return true;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other && other is TextFilter && runtimeType == other.runtimeType &&
              filterField == other.filterField && query == other.query;

  @override
  int get hashCode => super.hashCode ^ filterField.hashCode ^ query.hashCode;


}

extension PropertyFilterExtension on DatabaseProperty {
  PropertyFilter toPropertyFilter() {
    switch (type) {
      case PropertyType.Checkbox:
        return CheckboxFilter(propName: propName, value: true);
      case PropertyType.Title:
      case PropertyType.RichText:
      case PropertyType.URL:
      case PropertyType.PhoneNumber:
      case PropertyType.Email:
        return TextFilter(propName: propName, type: type, filterField: TextFilterField.contains);
      default:
        throw Exception('Property type not supported');
    }
  }
}
