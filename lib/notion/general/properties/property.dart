import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/utils/utils.dart';

/// A representation of a single property for any Notion object.
abstract class Property {
  /// The property type.
  final PropertiesTypes type = PropertiesTypes.None;

  /// The property id.
  String? id;

  /// The base getter for the content of any property.
  dynamic get value => false;

  /// The string value for this property type.
  String get strType => propertyTypeToString(type);

  /// Returns true if property is Title type.
  bool get isTitle => type == PropertiesTypes.Title;

  /// Returns true if property is RichText type.
  bool get isRichText => type == PropertiesTypes.RichText;

  /// Returns true if property is MultiSelect type.
  bool get isMultiSelect => type == PropertiesTypes.MultiSelect;

  /// Returns true if property don't have a known type.
  bool get isNone => type == PropertiesTypes.None;

  /// Main property constructor.
  ///
  /// Can receive the property [id].
  Property({this.id});

  /// Constructor for empty property.
  Property.empty();

  /// Convert this to a valid json representation for the Notion API.
  Map<String, dynamic> toJson() {
    if (type == PropertiesTypes.None) {
      throw 'None type for property';
    }

    Map<String, dynamic> json = {'type': strType};

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }

  // /// Map a list of properties from a [json] map.
  // abstract static Map<String, Property> propertiesFromJson(Map<String, dynamic> json);
  //
  // /// Create a new Property instance from json.
  // ///
  // /// Receive a [json] from where the information is extracted.
  // abstract static Property propertyFromJson(Map<String, dynamic> json);

  /// Check if the specific json have a content list.
  static bool contentIsList(Map<String, dynamic> json, PropertiesTypes type) =>
      fieldIsList(json[propertyTypeToString(type)]);

  /// Returns true if the properties are empty.
  static bool isEmpty(Map<String, dynamic> json, PropertiesTypes type) {
    if (json[propertyTypeToString(type)] != null) {
      return json[propertyTypeToString(type)]!.isEmpty;
    }
    return true;
  }
}

/// A representation of a multi select option property for any Notion object.
class MultiSelectOption {
  /// The option name.
  String name;

  /// The option id.
  String? id;

  /// The option color.
  ColorsTypes color;

  /// Main multi select option property constructor.
  ///
  /// Required the [name] field to display a text for the option. Also can receive the [id] and the [color] of the option.
  MultiSelectOption(
      {required this.name, this.id, this.color = ColorsTypes.Default});

  /// Create a new multi select instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  MultiSelectOption.fromJson(Map<String, dynamic> json)
      : this.name = json['name'] ?? '',
        this.id = json['id'],
        this.color = stringToColorType(json['color'] ?? '');

  /// Convert this to a valid json representation for the Notion API.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'name': name,
      'color': colorTypeToString(color),
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }

  /// Map a list of options from a [json] list with dynamics.
  static List<MultiSelectOption> fromListJson(List<dynamic> options) =>
      options.map((e) => MultiSelectOption.fromJson(e)).toList();
}