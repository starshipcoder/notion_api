import 'package:notion_api/notion.dart';
import 'package:notion_api/utils/utils.dart';

/// A representation of a single property for any Notion object.
class DatabaseProperty extends Property {
  /// Main property constructor.
  ///
  /// Can receive the property [id].
  DatabaseProperty({super.id});

  /// Constructor for empty property.
  DatabaseProperty.empty();

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

  /// Map a list of properties from a [json] map.
  static Map<String, DatabaseProperty> propertiesFromJson(Map<String, dynamic> json) {
    Map<String, DatabaseProperty> properties = {};
    json.entries.forEach((entry) {
      properties[entry.key] = DatabaseProperty.propertyFromJson(entry.value);
    });
    return properties;
  }

  /// Create a new Property instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  static DatabaseProperty propertyFromJson(Map<String, dynamic> json) {
    PropertiesTypes type = extractPropertyType(json);
    switch (type) {
      case PropertiesTypes.Title:
        return TitleDatabaseProperty.fromJson(json);
      case PropertiesTypes.RichText:
        return RichTextDatabaseProperty.fromJson(json);
      case PropertiesTypes.MultiSelect:
        bool contentIsList = MultiSelectDatabaseProperty.contentIsList(json);
        MultiSelectDatabaseProperty multi =
            MultiSelectDatabaseProperty.fromJson(json, subfield: contentIsList ? null : 'options');
        return multi;
      case PropertiesTypes.Status:
        return StatusDatabaseProperty.fromJson(json);
      case PropertiesTypes.Select:
        return SelectDatabaseProperty.fromJson(json);
      case PropertiesTypes.Number:
        return NumberDatabaseProperty.fromJson(json);
      case PropertiesTypes.Checkbox:
      //     return CheckboxDatabaseProperty.fromJson(json);
      // case PropertiesTypes.Date:
      //   return DateDatabaseProperty.fromJson(json);
      // return EmailDatabaseProperty.fromJson(json);
      //   case PropertiesTypes.PhoneNumber:
      //     return PhoneNumberDatabaseProperty.fromJson(json);
      case PropertiesTypes.URL:
      //   return URLDatabaseProperty.fromJson(json);

      case PropertiesTypes.PhoneNumber:
      case PropertiesTypes.Date:
      case PropertiesTypes.Email:
      default:
        return DatabaseProperty();
    }
  }

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

/// A representation of a title property for any Notion object.
class TitleDatabaseProperty extends DatabaseProperty {
  /// The property type. Always Title for this.
  @override
  final PropertiesTypes type = PropertiesTypes.Title;

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
  TitleDatabaseProperty({this.content = const <NotionText>[], this.name});

  /// Create a new property instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  TitleDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.name = json['name'] ?? '',
        this.content = NotionText.fromListJson(((json[propertyTypeToString(PropertiesTypes.Title)]['title']) ??
                []) as List)
            .toList(),
        super(id: json['id']);

  /// Convert this to a valid json representation for the Notion API.
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }
    if (this.name != null) {
      json['name'] = this.name;
    }

    json[this.strType] = this.content.map((e) => e.toJson()).toList();

    return json;
  }
}

/// A representation of a rich text property for any Notion object.
class RichTextDatabaseProperty extends DatabaseProperty {
  /// The property type. Always RichText for this.
  @override
  final PropertiesTypes type = PropertiesTypes.RichText;

  /// The list of rich text.
  List<NotionText> content;

  /// The value of the content.
  @override
  List<NotionText> get value => this.content;

  /// Main RichText constructor.
  ///
  /// Can receive the [content] as a list of texts.
  RichTextDatabaseProperty({this.content = const <NotionText>[]});

  /// Create a new rich text instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  RichTextDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.content = NotionText.fromListJson(json[propertyTypeToString(PropertiesTypes.RichText)] is List
            ? json[propertyTypeToString(PropertiesTypes.RichText)] as List
            : []),
        super(id: json['id']);

  /// Convert this to a valid json representation for the Notion API.
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': strType};

    if (id != null) {
      json['id'] = id;
    }

    json[strType] = content.map((e) => e.toJson()).toList();

    return json;
  }
}

/// A representation of the multi select Notion object.
class MultiSelectDatabaseProperty extends DatabaseProperty {
  /// The property type. Always MultiSelect for this.
  @override
  final PropertiesTypes type = PropertiesTypes.MultiSelect;

  List<MultiSelectOption> options;

  /// The options of the multi select.
  @override
  List<MultiSelectOption> get value => this.options;

  /// Main multi select constructor.
  ///
  /// Can receive the list6 of the options.
  MultiSelectDatabaseProperty({this.options = const <MultiSelectOption>[]});

  MultiSelectDatabaseProperty.fromJson(Map<String, dynamic> json, {String? subfield})
      : this.options = MultiSelectOption.fromListJson((subfield != null
            ? json[propertyTypeToString(PropertiesTypes.MultiSelect)][subfield]
            : json[propertyTypeToString(PropertiesTypes.MultiSelect)]) as List),
        super(id: json['id']);

  /// Add a new [option] to the multi select options and returns this instance.
  MultiSelectDatabaseProperty addOption(MultiSelectOption option) {
    this.options.add(option);
    return this;
  }

  /// Convert this to a valid json representation for the Notion API.
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': strType};

    if (id != null) {
      json['id'] = id;
    }

    json[strType] = {'options': options.map((e) => e.toJson()).toList()};

    return json;
  }

  /// Returns true if a json field is a list.
  static bool contentIsList(Map<String, dynamic> json) =>
      fieldIsList(json[propertyTypeToString(PropertiesTypes.MultiSelect)]);
}

/// A representation of a number property for any Notion object.
class NumberDatabaseProperty extends DatabaseProperty {
  final String name;
  final String format;

  @override
  final PropertiesTypes type = PropertiesTypes.Number;

  NumberDatabaseProperty(this.name, this.format);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json['number'] = {
      'name': name,
      'format': format,
    };

    return json;
  }

  NumberDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.format = json['number']['format'],
        super(id: json['id']);
}

/// A representation of a number property for any Notion object.
class CheckboxDatabaseProperty extends DatabaseProperty {
  bool value;

  @override
  final PropertiesTypes type = PropertiesTypes.Checkbox;

  CheckboxDatabaseProperty(this.value);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': 'checkbox', 'checkbox': this.value};

    if (this.id != null) {
      json['id'] = this.id;
    }

    return json;
  }

  CheckboxDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.value = json['checkbox'],
        super(id: json['id']);
}

/// A representation of a date property for any Notion object.
class DateDatabaseProperty extends DatabaseProperty {
  DateTime startDate;

  @override
  final PropertiesTypes type = PropertiesTypes.Date;

  DateDatabaseProperty({required this.startDate});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = {
      "start":
          "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}"
    };

    return json;
  }

  DateDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.startDate = DateTime.parse(json['date']['start']),
        super(id: json['id']);
}

class EmailDatabaseProperty extends DatabaseProperty {
  String email;

  @override
  final PropertiesTypes type = PropertiesTypes.Email;

  EmailDatabaseProperty({required this.email});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.email;

    return json;
  }

  EmailDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.email = (json['email'] is String) ? json['email'] : "",
        super(id: json['id']);
}

class PhoneNumberDatabaseProperty extends DatabaseProperty {
  String phone;

  @override
  final PropertiesTypes type = PropertiesTypes.PhoneNumber;

  PhoneNumberDatabaseProperty({required this.phone});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.phone;

    return json;
  }

  PhoneNumberDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.phone = json['phone_number'],
        super(id: json['id']);
}

class URLDatabaseProperty extends DatabaseProperty {
  String url;

  @override
  final PropertiesTypes type = PropertiesTypes.URL;

  URLDatabaseProperty({required this.url});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.url;

    return json;
  }

  URLDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.url = json['url'],
        super(id: json['id']);
}

class SelectDatabaseProperty extends DatabaseProperty {
  final String name;
  final List<Option> options;

  @override
  final PropertiesTypes type = PropertiesTypes.Select;

  SelectDatabaseProperty(this.name, this.options);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = {
      'name': this.name,
      'options': options.map((option) => option.toJson()).toList(),
    };

    return json;
  }

  SelectDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.options = (json['select']['options'] as List).map((e) => Option.fromJson(e)).toList(),
        super(id: json['id']);
}

class StatusDatabaseProperty extends DatabaseProperty {
  final String name;
  final List<Option> options;
  final List<Group> groups;

  @override
  final PropertiesTypes type = PropertiesTypes.Status;

  StatusDatabaseProperty(this.name, this.options, this.groups);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json['status'] = {
      'name': name,
      'options': options.map((option) => option.toJson()).toList(),
      'groups': groups.map((group) => group.toJson()).toList(),
    };

    return json;
  }

  StatusDatabaseProperty.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.options = (json['status']['options'] as List)
            .map((e) => Option.fromJson(e))
            .toList(),
        this.groups = (json['status']['groups'] as List)
            .map((e) => Group.fromJson(e))
            .toList(),
        super(id: json['id']);
}
