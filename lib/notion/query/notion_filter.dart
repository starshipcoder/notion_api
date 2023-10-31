import 'package:notion_api/notion/general/properties/database_property.dart';
import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/utils/utils.dart';

enum LogicOperator { and, or }

enum TextFilterField {
  contains,
  does_not_contain,
  does_not_equal,
  ends_with,
  equals,
  is_empty,
  is_not_empty,
  starts_with,
}

enum DateFilterField {
  after,
  before,
  equals,
  is_empty,
  is_not_empty,
  next_month,
  next_week,
  next_year,
  on_or_after,
  on_or_before,
  past_month,
  past_week,
  past_year,
  this_week,
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
      case TextFilterField.does_not_contain:
      case TextFilterField.does_not_equal:
      case TextFilterField.ends_with:
      case TextFilterField.equals:
      case TextFilterField.starts_with:
        return {
          'property': '$propName',
          '${type.toJsonName}': {
            '${filterField.name}': '$query',
          }
        };
      case TextFilterField.is_empty:
      case TextFilterField.is_not_empty:
        return {
          'property': '$propName',
          '${type.toJsonName}': {
            '${filterField.name}': true,
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
      case TextFilterField.does_not_contain:
      case TextFilterField.does_not_equal:
      case TextFilterField.ends_with:
      case TextFilterField.equals:
      case TextFilterField.starts_with:
        return query != null && query!.isNotEmpty;
      case TextFilterField.is_empty:
      case TextFilterField.is_not_empty:
        return true;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is TextFilter &&
              runtimeType == other.runtimeType &&
              filterField == other.filterField &&
              query == other.query;

  @override
  int get hashCode => super.hashCode ^ filterField.hashCode ^ query.hashCode;
}

class DateFilter extends PropertyFilter {
  final DateFilterField filterField;
  final String? date; // une date au format ISO-8601 ou Today

  DateFilter(
      {this.date, required super.propName, required this.filterField, required super.type});

  Map<String, dynamic> toJson() {
    switch (filterField) {
      case DateFilterField.after:
      case DateFilterField.before:
      case DateFilterField.equals:
      case DateFilterField.on_or_after:
      case DateFilterField.on_or_before:
        String _date = date!;
        if (date == "Today") {
          DateTime now = DateTime.now();
          _date = now.copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0).toIso8601String();
        }
        return {
          'property': '$propName',
          '${type.toJsonName}': {
            '${filterField.name}': '$_date',
          }
        };
      case DateFilterField.is_empty:
      case DateFilterField.is_not_empty:
        return {
          'property': '$propName',
          '${type.toJsonName}': {
            '${filterField.name}': true,
          }
        };
      case DateFilterField.next_month:
      case DateFilterField.next_week:
      case DateFilterField.next_year:
      case DateFilterField.past_month:
      case DateFilterField.past_week:
      case DateFilterField.past_year:
      case DateFilterField.this_week:
        return {
          'property': '$propName',
          '${type.toJsonName}': {
            '${filterField.name}': {},
          }
        };
    }
  }

  @override
  String toString() {
    return 'DateFilter{filterType: $filterField, date: $date}';
  }

  @override
  PropertyFilter generalCopyWith({String? propName, PropertyType? type}) {
    return copyWith(propName: propName, type: type);
  }

  DateFilter copyWith({String? propName,
    PropertyType? type,
    DateFilterField? filterField,
    String? date,
  }) {
    return DateFilter(
      type: type ?? this.type,
      propName: propName ?? this.propName,
      filterField: filterField ?? this.filterField,
      date: date ?? this.date,
    );
  }

  @override
  bool isValid() {
    switch (filterField) {
      case DateFilterField.is_empty:
      case DateFilterField.is_not_empty:
        return true;
      default:
        return date != null && date!.isNotEmpty;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is DateFilter &&
              runtimeType == other.runtimeType &&
              filterField == other.filterField &&
              date == other.date;

  @override
  int get hashCode => super.hashCode ^ filterField.hashCode ^ date.hashCode;
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
      case PropertyType.Date:
        return DateFilter(propName: propName, type: type, filterField: DateFilterField.this_week);
      default:
        throw Exception('Property type not supported');
    }
  }
}
