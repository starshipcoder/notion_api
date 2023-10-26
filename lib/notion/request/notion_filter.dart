import 'package:notion_api/notion/general/properties/database_property.dart';
import 'package:notion_api/notion/general/types/notion_types.dart';

abstract class PropertyFilter {
  final String propName;
  final PropertyType type;

  PropertyFilter({required this.propName, required this.type});

  Map<String, dynamic> toJson();
}

class CheckboxFilter extends PropertyFilter {
  final bool value;

  CheckboxFilter({required super.propName, required this.value}) : super(type: PropertyType.Checkbox);

  Map<String, dynamic> toJson() {
    return {
      'property': propName,
      'checkbox': {
        'equals': value,
      }
    };
  }

  @override
  String toString() {
    return 'CheckboxFilter{propName: $propName, value: $value}';
  }

  copyWith({bool? value}) {
    return CheckboxFilter(
      propName: propName,
        value: value ?? this.value
    );
  }

}

enum LogicOperator { and, or }

class DatabaseFilter {
  const DatabaseFilter(this.filters, [this.operator = LogicOperator.and]);

  final List<PropertyFilter> filters;
  final LogicOperator operator;

  Map<String, dynamic> toJson() {
    return {
      '${operator.name}': filters.map((filter) => filter.toJson()).toList(),
    };
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

extension PropertyFilterExtension on DatabaseProperty {
  PropertyFilter toPropertyFilter() {
    switch (type) {
      case PropertyType.Checkbox:
        return CheckboxFilter(propName: propName, value: true);
      default:
        throw Exception('Property type not supported');
    }
  }
}
