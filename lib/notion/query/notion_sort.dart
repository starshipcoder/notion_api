import 'package:notion_api/notion.dart';

enum SortDirection { ascending, descending }

class DatabaseSort {
  final String propName;
  final SortDirection direction;

  DatabaseSort({required this.propName, required this.direction});

  factory DatabaseSort.ascending(String propName) {
    return DatabaseSort(propName: propName, direction: SortDirection.ascending);
  }

  factory DatabaseSort.descending(String propName) {
    return DatabaseSort(propName: propName, direction: SortDirection.descending);
  }

  Map<String, String> toJson() {
    return {
      'property': '${propName}',
      "direction": '${direction.name}',
    };
  }

  @override
  String toString() {
    return 'DatabaseSort{propName: $propName, direction: $direction}';
  }

  copyWith({String? propName, SortDirection? direction}) {
    return DatabaseSort(
      propName: propName ?? this.propName,
      direction: direction ?? this.direction,
    );
  }
}

extension PropertySortExtension on DatabaseProperty {
  DatabaseSort toDatabaseSort() {
    switch (type) {
      case PropertyType.Checkbox:
      case PropertyType.Title:
      case PropertyType.RichText:
      case PropertyType.URL:
      case PropertyType.PhoneNumber:
      case PropertyType.Email:
      case PropertyType.Date:
      case PropertyType.Number:
      case PropertyType.Select:
      case PropertyType.MultiSelect:
      case PropertyType.CreatedTime:
      case PropertyType.LastEditedTime:
      case PropertyType.Status:
        return DatabaseSort.ascending(propName);
      default:
        throw Exception('DatabaseSort type not supported');
    }
  }
}
