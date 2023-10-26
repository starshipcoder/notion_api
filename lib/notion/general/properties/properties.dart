import 'package:notion_api/notion.dart';

/// A representation of the properties for any Notion object.
class DatabaseProperties {
  final Map<String, DatabaseProperty> _map = {};

  /// The properties map
  Map<String, DatabaseProperty> get entries => _map;

  /// Returns true if the properties map IS empty
  bool get isEmpty => this._map.isEmpty;

  /// Main properties constructor.
  ///
  /// Can receive a properties [map].
  DatabaseProperties({Map<String, DatabaseProperty> map = const {}}) {
    this._map.addAll(map);
  }

  /// Constructor for an empty instance.
  DatabaseProperties.empty();

  /// Map a new properties instance from a [json] map.
  DatabaseProperties.fromJson(Map<String, dynamic> json) {
    Map<String, DatabaseProperty> properties = DatabaseProperty.propertiesFromJson(json);
    this._map.addAll(properties);
  }

  /// Add a new [property] with a specific [name].
  void add({required String name, required DatabaseProperty property}) =>
      this._map[name] = property;

  /// Add a group of properties in a [json] map.
  void addAllFromJson(Map<String, dynamic> json) {
    Map<String, DatabaseProperty> properties = DatabaseProperty.propertiesFromJson(json);
    this._map.addAll(properties);
  }

  /// Remove the property with the specific [name] and return the deleted property. If not found return an empty instance.
  Property? remove(String name) => this._map.remove(name) ?? null;

  /// Get the property with the specific [name]. If not found return an empty instance.
  Property? getByName(String name) => this._map[name] ?? null;

  /// Returns true if the property with the specific [name] is contained.
  bool contains(String name) => this._map.containsKey(name);

  /// Convert this to a valid json representation for the Notion API.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    this._map.entries.forEach((element) {
      json[element.key] = element.value.toJson();
    });

    return json;
  }
}

class PageProperties {
  final Map<String, PageProperty> _map = {};

  /// The properties map
  Map<String, PageProperty> get entries => _map;

  /// Returns true if the properties map IS empty
  bool get isEmpty => this._map.isEmpty;

  /// Main properties constructor.
  ///
  /// Can receive a properties [map].
  PageProperties({Map<String, PageProperty> map = const {}}) {
    this._map.addAll(map);
  }

  /// Constructor for an empty instance.
  PageProperties.empty();

  /// Map a new properties instance from a [json] map.
  PageProperties.fromJson(Map<String, dynamic> json) {
    Map<String, PageProperty> properties = PageProperty.propertiesFromJson(json);
    this._map.addAll(properties);
  }

  /// Add a new [property] with a specific [name].
  void add({required String name, required PageProperty property}) =>
      this._map[name] = property;

  /// Add a group of properties in a [json] map.
  void addAllFromJson(Map<String, dynamic> json) {
    Map<String, PageProperty> properties = PageProperty.propertiesFromJson(json);
    this._map.addAll(properties);
  }

  /// Remove the property with the specific [name] and return the deleted property. If not found return an empty instance.
  Property? remove(String name) => this._map.remove(name) ?? null;

  /// Get the property with the specific [name]. If not found return an empty instance.
  Property? getByName(String name) => this._map[name] ?? null;

  /// Returns true if the property with the specific [name] is contained.
  bool contains(String name) => this._map.containsKey(name);

  /// Convert this to a valid json representation for the Notion API.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    this._map.entries.forEach((element) {
      json[element.key] = element.value.toJson();
    });

    return json;
  }
}
