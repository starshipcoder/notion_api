import 'package:notion_api/notion.dart';
import 'package:notion_api/utils/utils.dart';

/// A representation of a single property for any Notion object.
class DatabaseProperty extends Property {
  /// Main property constructor.
  ///
  /// Can receive the property [id].
  DatabaseProperty({required super.id, required super.propName});

  /// Convert this to a valid json representation for the Notion API.
  Map<String, dynamic> toJson() {
    if (type == PropertyType.None) {
      throw 'None type for property';
    }

    Map<String, dynamic> json = {'type': strType};

    json['id'] = id;

    return json;
  }

  /// Map a list of properties from a [json] map.
  static Map<String, DatabaseProperty> propertiesFromJson(Map<String, dynamic> json) {
    Map<String, DatabaseProperty> properties = {};
    json.entries.forEach((entry) {
      properties[entry.key] = DatabaseProperty.propertyFromJson(entry.value, entry.key);
    });
    return properties;
  }

  /// Create a new Property instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  static DatabaseProperty propertyFromJson(Map<String, dynamic> json, String propName) {
    PropertyType type = extractPropertyType(json);
    switch (type) {
      // case PropertyType.Title:
      //   return TitleDatabaseProperty.fromJson(json, propName);
      // case PropertyType.RichText:
      //   return RichTextDatabaseProperty.fromJson(json, propName);
      case PropertyType.MultiSelect:
        return MultiSelectDatabaseProperty.fromJson(json, propName);
      case PropertyType.Status:
        return StatusDatabaseProperty.fromJson(json, propName);
      case PropertyType.Select:
        return SelectDatabaseProperty.fromJson(json, propName);
      case PropertyType.Number:
        return NumberDatabaseProperty.fromJson(json, propName);
      case PropertyType.Date:
     //   return DateDatabaseProperty.fromJson(json, propName);
      // return EmailDatabaseProperty.fromJson(json);
      //   case PropertiesTypes.PhoneNumber:
      //     return PhoneNumberDatabaseProperty.fromJson(json);
      case PropertyType.Checkbox:
      case PropertyType.Title:
      case PropertyType.RichText:
      case PropertyType.URL:
      case PropertyType.PhoneNumber:
      case PropertyType.Email:
      default:
        return TypedDatabaseProperty(type: type, id: json['id'], propName: propName);
    }
  }

  /// Returns true if the properties are empty.
  static bool isEmpty(Map<String, dynamic> json, PropertyType type) {
    if (json[type.toJsonName] != null) {
      return json[type.toJsonName]!.isEmpty;
    }
    return true;
  }
}

// pour les properties qui n'ont que le type
class TypedDatabaseProperty extends DatabaseProperty {
  final PropertyType type;

  TypedDatabaseProperty({required this.type, required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    return json;
  }
}

/// A representation of a title property for any Notion object.
class TitleDatabaseProperty extends DatabaseProperty {
  /// The property type. Always Title for this.
  @override
  final PropertyType type = PropertyType.Title;

  /// The property name.
  String? name;

  /// The property content.
  List<NotionText> content;

  /// The value of the content.
  @override
  List<NotionText> get value => this.content;

  /// Main title property constructor.
  ///
  /// Can receive a list ot texts as the title [content].
  TitleDatabaseProperty({this.content = const <NotionText>[], required super.propName, required super.id});

  /// Create a new property instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  TitleDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.name = json['name'] ?? '',
        this.content =
            NotionText.fromListJson(((json[PropertyType.Title.toJsonName]['title']) ?? []) as List).toList(),
        super(id: json['id'], propName: propName);

  /// Convert this to a valid json representation for the Notion API.
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;
    json['name'] = this.name;

    json[this.strType] = this.content.map((e) => e.toJson()).toList();

    return json;
  }
}

/// A representation of a rich text property for any Notion object.
class RichTextDatabaseProperty extends DatabaseProperty {
  /// The property type. Always RichText for this.
  @override
  final PropertyType type = PropertyType.RichText;

  /// The list of rich text.
  List<NotionText> content;

  /// The value of the content.
  @override
  List<NotionText> get value => this.content;

  /// Main RichText constructor.
  ///
  /// Can receive the [content] as a list of texts.
  RichTextDatabaseProperty({this.content = const <NotionText>[], required super.id, required super.propName});

  /// Create a new rich text instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  RichTextDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.content = NotionText.fromListJson(json[PropertyType.RichText.toJsonName] is List
            ? json[PropertyType.RichText.toJsonName] as List
            : []),
        super(id: json['id'], propName: propName);

  /// Convert this to a valid json representation for the Notion API.
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': strType};

    json['id'] = id;

    json[strType] = content.map((e) => e.toJson()).toList();

    return json;
  }
}

/// A representation of the multi select Notion object.
class MultiSelectDatabaseProperty extends DatabaseProperty {
  /// The property type. Always MultiSelect for this.
  @override
  final PropertyType type = PropertyType.MultiSelect;

  List<MultiSelectOption> options;

  /// The options of the multi select.
  @override
  List<MultiSelectOption> get value => this.options;

  /// Main multi select constructor.
  ///
  /// Can receive the list6 of the options.
  MultiSelectDatabaseProperty({this.options = const <MultiSelectOption>[], required super.id, required super.propName});

  MultiSelectDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.options =
            MultiSelectOption.fromListJson((json[PropertyType.MultiSelect.toJsonName]['options']) as List),
        super(id: json['id'], propName: propName);

  /// Add a new [option] to the multi select options and returns this instance.
  MultiSelectDatabaseProperty addOption(MultiSelectOption option) {
    this.options.add(option);
    return this;
  }

  /// Convert this to a valid json representation for the Notion API.
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': strType};

    json['id'] = id;

    json[strType] = {'options': options.map((e) => e.toJson()).toList()};

    return json;
  }
}

/// A representation of a number property for any Notion object.
class NumberDatabaseProperty extends DatabaseProperty {
  final String name;
  final String format;

  @override
  final PropertyType type = PropertyType.Number;

  NumberDatabaseProperty(this.name, this.format, {required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json['number'] = {
      'name': name,
      'format': format,
    };

    return json;
  }

  NumberDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.name = json['name'],
        this.format = json['number']['format'],
        super(id: json['id'], propName: propName);
}

/// A representation of a number property for any Notion object.
class CheckboxDatabaseProperty extends DatabaseProperty {
  bool value;

  @override
  final PropertyType type = PropertyType.Checkbox;

  CheckboxDatabaseProperty(this.value, {required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': 'checkbox', 'checkbox': this.value};

    json['id'] = this.id;

    return json;
  }

  CheckboxDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.value = json['checkbox'],
        super(id: json['id'], propName: propName);
}

/// A representation of a date property for any Notion object.
class DateDatabaseProperty extends DatabaseProperty {
  @override
  final PropertyType type = PropertyType.Date;

  DateDatabaseProperty({required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    return json;
  }

  DateDatabaseProperty.fromJson(Map<String, dynamic> json, String propName) : super(id: json['id'], propName: propName);
}

class EmailDatabaseProperty extends DatabaseProperty {
  String email;

  @override
  final PropertyType type = PropertyType.Email;

  EmailDatabaseProperty({required this.email, required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.email;

    return json;
  }

  EmailDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.email = (json['email'] is String) ? json['email'] : "",
        super(id: json['id'], propName: propName);
}

class PhoneNumberDatabaseProperty extends DatabaseProperty {
  String phone;

  @override
  final PropertyType type = PropertyType.PhoneNumber;

  PhoneNumberDatabaseProperty({required this.phone, required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.phone;

    return json;
  }

  PhoneNumberDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.phone = json['phone_number'],
        super(id: json['id'], propName: propName);
}

class URLDatabaseProperty extends DatabaseProperty {
  String url;

  @override
  final PropertyType type = PropertyType.URL;

  URLDatabaseProperty({required this.url, required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.url;

    return json;
  }

  URLDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.url = json['url'],
        super(id: json['id'], propName: propName);
}

class SelectDatabaseProperty extends DatabaseProperty {
  final String name;
  final List<Option> options;

  @override
  final PropertyType type = PropertyType.Select;

  SelectDatabaseProperty(this.name, this.options, {required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = {
      'name': this.name,
      'options': options.map((option) => option.toJson()).toList(),
    };

    return json;
  }

  SelectDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.name = json['name'],
        this.options = (json['select']['options'] as List).map((e) => Option.fromJson(e)).toList(),
        super(id: json['id'], propName: propName);
}

class StatusDatabaseProperty extends DatabaseProperty {
  final String name;
  final List<Option> options;
  final List<Group> groups;

  @override
  final PropertyType type = PropertyType.Status;

  StatusDatabaseProperty(this.name, this.options, this.groups, {required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json['status'] = {
      'name': name,
      'options': options.map((option) => option.toJson()).toList(),
      'groups': groups.map((group) => group.toJson()).toList(),
    };

    return json;
  }

  StatusDatabaseProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.name = json['name'],
        this.options = (json['status']['options'] as List).map((e) => Option.fromJson(e)).toList(),
        this.groups = (json['status']['groups'] as List).map((e) => Group.fromJson(e)).toList(),
        super(id: json['id'], propName: propName);
}
