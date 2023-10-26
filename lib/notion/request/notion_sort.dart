

enum SortDirection { ascending, descending }

class DatabaseSort {
  final String property;
  final SortDirection direction;

  DatabaseSort(this.property, this.direction);

  factory DatabaseSort.ascending(String property) {
    return DatabaseSort(property, SortDirection.ascending);
  }

  factory DatabaseSort.descending(String property) {
    return DatabaseSort(property, SortDirection.descending);
  }

  Map<String, String> toJson() {
    return {
      "property": property,
      "direction": direction.name,
    };
  }
}