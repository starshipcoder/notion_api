import 'package:notion_api/notion.dart';

class DatabaseQuery {
  const DatabaseQuery({this.filters = const [], this.sorts = const [], this.filterOperator = LogicOperator.and});

  final List<PropertyFilter> filters;
  final LogicOperator filterOperator;
  final List<DatabaseSort> sorts;


  Map<String, dynamic> toFilterJson() {
    List<PropertyFilter> validFilters = this.filters.where((element) => element.isValid()).toList();

    if (validFilters.isEmpty) return {};
    if (validFilters.length == 1) return validFilters.first.toJson();
    return {
      '${filterOperator.name}': validFilters.map((filter) => filter.toJson()).toList(),
    };
  }

  List<dynamic> toSortJson() {
    if (sorts.isEmpty) return [];
    return sorts.map((sorts) => sorts.toJson()).toList();
  }


  bool isFilterValid() {
    return filters.any((element) => element.isValid());
  }

  DatabaseQuery copyWith({List<PropertyFilter>? filters, LogicOperator? filterOperator, List<DatabaseSort>? sorts}) {
    return DatabaseQuery(
      filters: filters ?? this.filters,
      filterOperator: filterOperator ?? this.filterOperator,
      sorts: sorts ?? this.sorts,
    );
  }

  @override
  String toString() {
    return 'DatabaseQuery{filters: $filters, operator: $filterOperator, sorts: $sorts}';
  }
}