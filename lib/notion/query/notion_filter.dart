import 'package:notion_api/notion/general/properties/database_property.dart';
import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/utils/utils.dart';

enum LogicOperator { and, or }

enum TextFilterField {
  contains,
  does_not_contain,
  equals,
  does_not_equal,
  starts_with,
  ends_with,
  is_empty,
  is_not_empty,
}

enum DateFilterField {
  before,
  after,
  on_or_before,
  on_or_after,
  equals,
  this_week,
  next_week,
  next_month,
  next_year,
  past_week,
  past_month,
  past_year,
  is_empty,
  is_not_empty,
}

enum SelectFilterField {
  equals,
  does_not_equal,
  is_empty,
  is_not_empty,
}

enum StatusFilterField {
  equals,
  does_not_equal,
  is_empty,
  is_not_empty,
}

enum MultiSelectFilterField {
  contains,
  does_not_contain,
  is_empty,
  is_not_empty,
}

enum NumberFilterField {
  equals,
  does_not_equal,
  greater_than,
  less_than,
  greater_than_or_equal_to,
  less_than_or_equal_to,
  is_empty,
  is_not_empty,
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
      other is PropertyFilter && runtimeType == other.runtimeType && propName == other.propName && type == other.type;

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

  DateFilter({this.date, required super.propName, required this.filterField, required super.type});

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

  DateFilter copyWith({
    String? propName,
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

class MultiSelectFilter extends PropertyFilter {
  final List<String> values;
  final MultiSelectFilterField filterField;

  MultiSelectFilter({required super.propName, required this.values, required this.filterField})
      : super(type: PropertyType.MultiSelect);

  @override
  Map<String, dynamic> toJson() {
    switch (filterField) {
      case MultiSelectFilterField.contains:
      case MultiSelectFilterField.does_not_contain:
        if (values.length == 1) {
          return {
            'property': '$propName',
            'multi_select': {
              '${filterField.name}': '$values',
            }
          };
        } else {
          return {
            "or": values
                .map((e) => {
                      'property': '$propName',
                      'multi_select': {
                        '${filterField.name}': '$e',
                      }
                    })
                .toList()
          };
        }
      case MultiSelectFilterField.is_empty:
      case MultiSelectFilterField.is_not_empty:
        return {
          'property': '$propName',
          'multi_select': {
            '${filterField.name}': true,
          }
        };
    }
  }

  @override
  bool isValid() {
    switch (filterField) {
      case MultiSelectFilterField.contains:
      case MultiSelectFilterField.does_not_contain:
        return values.isNotEmpty;
      case MultiSelectFilterField.is_empty:
      case MultiSelectFilterField.is_not_empty:
        return true;
    }
  }

  @override
  PropertyFilter generalCopyWith({String? propName, PropertyType? type}) {
    return copyWith(propName: propName);
  }

  MultiSelectFilter copyWith({List<String>? values, String? propName, MultiSelectFilterField? filterField}) {
    return MultiSelectFilter(
      propName: propName ?? this.propName,
      values: values ?? this.values,
      filterField: filterField ?? this.filterField,
    );
  }

  @override
  String toString() => 'MultiSelectFilter{propName: $propName, filterField: $filterField, values: $values}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is MultiSelectFilter && runtimeType == other.runtimeType && values == other.values;

  @override
  int get hashCode => super.hashCode ^ values.hashCode;
}

class SelectFilter extends PropertyFilter {
  final List<String> values;
  final SelectFilterField filterField;

  SelectFilter({required super.propName, required this.values, required this.filterField})
      : super(type: PropertyType.Select);

  @override
  Map<String, dynamic> toJson() {
    switch (filterField) {
      case SelectFilterField.equals:
      case SelectFilterField.does_not_equal:
        if (values.length == 1) {
          return {
            'property': '$propName',
            'select': {
              '${filterField.name}': '${values.first}',
            }
          };
        } else {
          return {
            "or": values
                .map((e) => {
                      'property': '$propName',
                      'select': {
                        '${filterField.name}': '$e',
                      }
                    })
                .toList()
          };
        }
      case SelectFilterField.is_empty:
      case SelectFilterField.is_not_empty:
        return {
          'property': '$propName',
          'select': {
            '${filterField.name}': true,
          }
        };
    }
  }

  @override
  bool isValid() {
    switch (filterField) {
      case SelectFilterField.equals:
      case SelectFilterField.does_not_equal:
        return values.isNotEmpty;
      case SelectFilterField.is_empty:
      case SelectFilterField.is_not_empty:
        return true;
    }
  }

  @override
  PropertyFilter generalCopyWith({String? propName, PropertyType? type}) {
    return copyWith(propName: propName);
  }

  SelectFilter copyWith({List<String>? values, String? propName, SelectFilterField? filterField}) {
    return SelectFilter(
      propName: propName ?? this.propName,
      values: values ?? this.values,
      filterField: filterField ?? this.filterField,
    );
  }

  @override
  String toString() => 'SelectFilter{propName: $propName, filterField: $filterField, values: $values}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is SelectFilter && runtimeType == other.runtimeType && values == other.values;

  @override
  int get hashCode => super.hashCode ^ values.hashCode;
}

class StatusFilter extends PropertyFilter {
  final List<String> values;
  final StatusFilterField filterField;

  StatusFilter({required super.propName, required this.values, required this.filterField})
      : super(type: PropertyType.Status);

  @override
  Map<String, dynamic> toJson() {
    switch (filterField) {
      case StatusFilterField.equals:
      case StatusFilterField.does_not_equal:
        if (values.length == 1) {
          return {
            'property': '$propName',
            'status': {
              '${filterField.name}': '${values.first}',
            }
          };
        } else {
          return {
            "or": values
                .map((e) => {
                      'property': '$propName',
                      'status': {
                        '${filterField.name}': '$e',
                      }
                    })
                .toList()
          };
        }
      case StatusFilterField.is_empty:
      case StatusFilterField.is_not_empty:
        return {
          'property': '$propName',
          'status': {
            '${filterField.name}': true,
          }
        };
    }
  }

  @override
  bool isValid() {
    switch (filterField) {
      case StatusFilterField.equals:
      case StatusFilterField.does_not_equal:
        return values.isNotEmpty;
      case StatusFilterField.is_empty:
      case StatusFilterField.is_not_empty:
        return true;
    }
  }

  @override
  PropertyFilter generalCopyWith({String? propName, PropertyType? type}) {
    return copyWith(propName: propName);
  }

  StatusFilter copyWith({List<String>? values, String? propName, StatusFilterField? filterField}) {
    return StatusFilter(
      propName: propName ?? this.propName,
      values: values ?? this.values,
      filterField: filterField ?? this.filterField,
    );
  }

  @override
  String toString() => 'StatusFilter{propName: $propName, filterField: $filterField, values: $values}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is StatusFilter && runtimeType == other.runtimeType && values == other.values;

  @override
  int get hashCode => super.hashCode ^ values.hashCode;
}

class NumberFilter extends PropertyFilter {
  final double number;
  final NumberFilterField filterField;

  NumberFilter({required super.propName, required this.number, required this.filterField})
      : super(type: PropertyType.Number);

  @override
  Map<String, dynamic> toJson() {
    switch (filterField) {
      case NumberFilterField.equals:
      case NumberFilterField.does_not_equal:
      case NumberFilterField.greater_than:
      case NumberFilterField.less_than:
      case NumberFilterField.greater_than_or_equal_to:
      case NumberFilterField.less_than_or_equal_to:
        return {
          'property': '$propName',
          'number': {
            '${filterField.name}': number,
          }
        };
      case NumberFilterField.is_empty:
      case NumberFilterField.is_not_empty:
        return {
          'property': '$propName',
          'number': {
            '${filterField.name}': true,
          }
        };
    }
  }

  @override
  bool isValid() => true;

  @override
  PropertyFilter generalCopyWith({String? propName, PropertyType? type}) {
    return copyWith(propName: propName);
  }

  NumberFilter copyWith({double? number, String? propName, NumberFilterField? filterField}) {
    return NumberFilter(
      propName: propName ?? this.propName,
      number: number ?? this.number,
      filterField: filterField ?? this.filterField,
    );
  }

  @override
  String toString() => 'NumberFilter{propName: $propName, filterField: $filterField, number: $number}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is NumberFilter && runtimeType == other.runtimeType && number == other.number;

  @override
  int get hashCode => super.hashCode ^ number.hashCode;
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
        return DateFilter(propName: propName, type: type, filterField: DateFilterField.on_or_before, date: "Today");
      case PropertyType.Number:
        return NumberFilter(propName: propName, filterField: NumberFilterField.greater_than, number: 0);
      case PropertyType.Select:
        return SelectFilter(propName: propName, filterField: SelectFilterField.equals, values: []);
      case PropertyType.MultiSelect:
        return MultiSelectFilter(propName: propName, filterField: MultiSelectFilterField.contains, values: []);
      case PropertyType.Status:
        return StatusFilter(propName: propName, filterField: StatusFilterField.equals, values: []);
      default:
        throw Exception('Property type not supported');
    }
  }
}
