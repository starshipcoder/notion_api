import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/utils/utils.dart';

/// A representation of a single property for any Notion object.
abstract class Property {
  /// The property type.
  final PropertyType type = PropertyType.None;

  /// The property id.
  final String id;

  final String propName;

  /// The base getter for the content of any property.
  dynamic get value => false;

  /// The string value for this property type.
  String get strType => propertyTypeToString(type);

  /// Returns true if property is Title type.
  bool get isTitle => type == PropertyType.Title;

  /// Returns true if property is RichText type.
  bool get isRichText => type == PropertyType.RichText;

  /// Returns true if property is MultiSelect type.
  bool get isMultiSelect => type == PropertyType.MultiSelect;

  /// Returns true if property don't have a known type.
  bool get isNone => type == PropertyType.None;

  /// Main property constructor.
  ///
  /// Can receive the property [id].
  Property({required this.id, required this.propName});

  /// Constructor for empty property.
  //Property.empty();

  /// Convert this to a valid json representation for the Notion API.
  Map<String, dynamic> toJson() {
    if (type == PropertyType.None) {
      throw 'None type for property';
    }

    Map<String, dynamic> json = {'type': strType};

    json['id'] = id;


    return json;
  }

  // /// Map a list of properties from a [json] map.
  // abstract static Map<String, Property> propertiesFromJson(Map<String, dynamic> json);
  //
  // /// Create a new Property instance from json.
  // ///
  // /// Receive a [json] from where the information is extracted.
  // abstract static Property propertyFromJson(Map<String, dynamic> json);

  /// Returns true if the properties are empty.
  static bool isEmpty(Map<String, dynamic> json, PropertyType type) {
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

class Option {
  final String id;
  final String name;
  final String color;

  Option(this.id, this.name, this.color);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      json['id'],
      json['name'],
      json['color'],
    );
  }
}

class Group {
  final String id;
  final String name;
  final String color;
  final List<String> optionIds;

  Group(this.id, this.name, this.color, this.optionIds);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'option_ids': optionIds,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      json['id'],
      json['name'],
      json['color'],
      List<String>.from(json['option_ids']),
    );
  }
}