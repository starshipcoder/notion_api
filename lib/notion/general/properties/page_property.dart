import 'package:notion_api/notion.dart';
import 'package:notion_api/utils/utils.dart';

/// A representation of a single property for any Notion object.
class PageProperty extends Property {
  /// Main property constructor.
  ///
  /// Can receive the property [id].
  PageProperty({required super.id, required super.propName});

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
  static Map<String, PageProperty> propertiesFromJson(Map<String, dynamic> json) {
    Map<String, PageProperty> properties = {};
    json.entries.forEach((entry) {
      properties[entry.key] = PageProperty.propertyFromJson(entry.value, entry.key);
    });
    return properties;
  }

  /// Create a new Property instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  static PageProperty propertyFromJson(Map<String, dynamic> json, String propName) {
    PropertyType type = extractPropertyType(json);
    switch (type) {
      case PropertyType.Title:
        return TitlePageProperty.fromJson(json, propName);
      case PropertyType.RichText:
        return RichTextPageProperty.fromJson(json, propName);
      case PropertyType.MultiSelect:
        return MultiSelectPageProperty.fromJson(json, propName);
      case PropertyType.Select:
        return SelectPageProperty.fromJson(json, propName);
      case PropertyType.Number:
        return NumberPageProperty.fromJson(json, propName);
      case PropertyType.Checkbox:
        return CheckboxPageProperty.fromJson(json, propName);
      case PropertyType.Date:
        return DatePageProperty.fromJson(json, propName);
      case PropertyType.Email:
        return EmailPageProperty.fromJson(json, propName);
      case PropertyType.PhoneNumber:
        return PhoneNumberPageProperty.fromJson(json, propName);
      case PropertyType.URL:
        return URLPageProperty.fromJson(json, propName);
      case PropertyType.Status:
        return StatusPageProperty.fromJson(json, propName);
      default:
        return PageProperty(id: json['id'], propName: propName);
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

/// A representation of a title property for any Notion object.
class TitlePageProperty extends PageProperty {
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
  TitlePageProperty({this.content = const <NotionText>[], required super.propName, required super.id});

  /// Create a new property instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  TitlePageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.name = json['name'] ?? '',
        this.content = NotionText.fromListJson(((json[PropertyType.Title.toJsonName]) ?? []) as List).toList(),
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
class RichTextPageProperty extends PageProperty {
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
  // RichTextPageProperty({this.content = const <NotionText>[]});

  /// Create a new rich text instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  RichTextPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.content = NotionText.fromListJson(
            json[PropertyType.RichText.toJsonName] is List ? json[PropertyType.RichText.toJsonName] as List : []),
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
class MultiSelectPageProperty extends PageProperty {
  /// The property type. Always MultiSelect for this.
  @override
  final PropertyType type = PropertyType.MultiSelect;

  List<Option> options;

  /// The options of the multi select.
  @override
  List<Option> get value => this.options;

  /// Main multi select constructor.
  ///
  /// Can receive the list6 of the options.
  MultiSelectPageProperty({this.options = const <Option>[], required super.id, required super.propName});

  MultiSelectPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.options = ((json[PropertyType.MultiSelect.toJsonName]) as List).map((e) => Option.fromJson(e)).toList(),
        super(id: json['id'], propName: propName);

  /// Add a new [option] to the multi select options and returns this instance.
  MultiSelectPageProperty addOption(Option option) {
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
class NumberPageProperty extends PageProperty {
  num? value;

  @override
  final PropertyType type = PropertyType.Number;

  NumberPageProperty(this.value, {required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.value;

    return json;
  }

  NumberPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.value = json['number'],
        super(id: json['id'], propName: propName);
}

/// A representation of a number property for any Notion object.
class CheckboxPageProperty extends PageProperty {
  bool value;

  @override
  final PropertyType type = PropertyType.Checkbox;

  CheckboxPageProperty(this.value, {required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': 'checkbox', 'checkbox': this.value};

    json['id'] = this.id;

    return json;
  }

  CheckboxPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.value = json['checkbox'],
        super(id: json['id'], propName: propName);
}

/// A representation of a date property for any Notion object.
class DatePageProperty extends PageProperty {
  DateTime? startDate;
  DateTime? endDate;
  String? timeZone;

  // Utilisation d'un getter pour accéder à une représentation sous forme de chaîne de la date
  String? get formattedStartDate => formatDate(startDate);

  String? get formattedEndDate => formatDate(endDate);

  @override
  final PropertyType type = PropertyType.Date;

  DatePageProperty({required this.startDate, required super.id, required super.propName});

  // Méthode utilitaire pour formater une date
  String? formatDate(DateTime? date) {
    if (date == null) return null;
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = {"start": formattedStartDate, "end": formattedEndDate, "time_zone": timeZone};

    return json;
  }

  DatePageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.startDate = tryParseDate(json, 'start'),
        this.endDate = tryParseDate(json, 'end'),
        this.timeZone = json['date']?['time_zone'],
        super(id: json['id'], propName: propName);

  // Méthode utilitaire pour essayer de parser une date
  static DateTime? tryParseDate(Map<String, dynamic> json, String key) {
    try {
      return json['date'] != null && json['date'][key] != null ? DateTime.parse(json['date'][key]) : null;
    } catch (e) {
      print("Erreur lors du parsing de la date : $e");
      return null;
    }
  }
}

class EmailPageProperty extends PageProperty {
  String email;

  @override
  final PropertyType type = PropertyType.Email;

  EmailPageProperty({required this.email, required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.email;

    return json;
  }

  EmailPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.email = (json['email'] is String) ? json['email'] : "",
        super(id: json['id'], propName: propName);
}

class PhoneNumberPageProperty extends PageProperty {
  String phone;

  @override
  final PropertyType type = PropertyType.PhoneNumber;

  PhoneNumberPageProperty({required this.phone, required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.phone;

    return json;
  }

  PhoneNumberPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.phone = json['phone_number'] ?? "",
        super(id: json['id'], propName: propName);
}

class URLPageProperty extends PageProperty {
  String url;

  @override
  final PropertyType type = PropertyType.URL;

  URLPageProperty({required this.url, required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.url;

    return json;
  }

  URLPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.url = json['url'],
        super(id: json['id'], propName: propName);
}

class SelectPageProperty extends PageProperty {
  String name;
  ColorsTypes color;

  @override
  final PropertyType type = PropertyType.Select;

  SelectPageProperty(this.name, this.color, {required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.value?.toFilterJson();

    return json;
  }

  SelectPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.name = json['select']['name'],
        this.color = stringToColorType(json['select']['color'] ?? ''),
        super(id: json['id'], propName: propName);
}

class StatusPageProperty extends PageProperty {
  String name;
  ColorsTypes color;

  @override
  final PropertyType type = PropertyType.Status;

  StatusPageProperty(this.name, this.color, {required super.id, required super.propName});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    json['id'] = this.id;

    json[this.strType] = this.value?.toFilterJson();

    return json;
  }

  StatusPageProperty.fromJson(Map<String, dynamic> json, String propName)
      : this.name = json['status']['name'],
        this.color = stringToColorType(json['status']['color'] ?? ''),
        super(id: json['id'], propName: propName);
}
