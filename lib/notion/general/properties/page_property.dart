import 'package:notion_api/notion.dart';
import 'package:notion_api/notion/general/rich_text.dart';
import 'package:notion_api/utils/utils.dart';

/// A representation of a single property for any Notion object.
class PageProperty extends Property {
  /// Main property constructor.
  ///
  /// Can receive the property [id].
  PageProperty({super.id});

  /// Constructor for empty property.
  PageProperty.empty();

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
  static Map<String, PageProperty> propertiesFromJson(Map<String, dynamic> json) {
    Map<String, PageProperty> properties = {};
    json.entries.forEach((entry) {
      properties[entry.key] = PageProperty.propertyFromJson(entry.value);
    });
    return properties;
  }

  /// Create a new Property instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  static PageProperty propertyFromJson(Map<String, dynamic> json) {
    PropertiesTypes type = extractPropertyType(json);
    switch (type) {
      case PropertiesTypes.Title:
        bool contentIsList = Property.contentIsList(json, type);
        return TitlePageProperty.fromJson(json, subfield: contentIsList ? null : 'title');
      case PropertiesTypes.RichText:
        return RichTextPageProperty.fromJson(json);
      case PropertiesTypes.MultiSelect:
        bool contentIsList = MultiSelectPageProperty.contentIsList(json);
        MultiSelectPageProperty multi =
            MultiSelectPageProperty.fromJson(json, subfield: contentIsList ? null : 'options');
        return multi;
      case PropertiesTypes.Select:
        return SelectPageProperty.fromJson(json);
      case PropertiesTypes.Number:
        return NumberPageProperty.fromJson(json);
      case PropertiesTypes.Checkbox:
        return CheckboxPageProperty.fromJson(json);
      case PropertiesTypes.Date:
        return DatePageProperty.fromJson(json);
      case PropertiesTypes.Email:
        print("------------json $json");
        return EmailPageProperty.fromJson(json);
      case PropertiesTypes.PhoneNumber:
        return PhoneNumberPageProperty.fromJson(json);
      case PropertiesTypes.URL:
        return URLPageProperty.fromJson(json);
      case PropertiesTypes.Status:
        return StatusPageProperty.fromJson(json);
      default:
        return PageProperty();
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
class TitlePageProperty extends PageProperty {
  /// The property type. Always Title for this.
  @override
  final PropertiesTypes type = PropertiesTypes.Title;

  /// The property name.
  String? name;

  /// The property content.
  List<Text> content;

  /// The value of the content.
  @override
  List<Text> get value => this.content;

  /// Main title property constructor.
  ///
  /// Can receive a list ot texts as the title [content].
  TitlePageProperty({this.content = const <Text>[], this.name});

  /// Create a new property instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  TitlePageProperty.fromJson(Map<String, dynamic> json, {String? subfield})
      : this.name = json['name'] ?? '',
        this.content = Text.fromListJson(((subfield != null
                    ? json[propertyTypeToString(PropertiesTypes.Title)][subfield]
                    : json[propertyTypeToString(PropertiesTypes.Title)]) ??
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
class RichTextPageProperty extends PageProperty {
  /// The property type. Always RichText for this.
  @override
  final PropertiesTypes type = PropertiesTypes.RichText;

  /// The list of rich text.
  List<Text> content;

  /// The value of the content.
  @override
  List<Text> get value => this.content;

  /// Main RichText constructor.
  ///
  /// Can receive the [content] as a list of texts.
  RichTextPageProperty({this.content = const <Text>[]});

  /// Create a new rich text instance from json.
  ///
  /// Receive a [json] from where the information is extracted.
  RichTextPageProperty.fromJson(Map<String, dynamic> json)
      : this.content = Text.fromListJson(json[propertyTypeToString(PropertiesTypes.RichText)] is List
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
class MultiSelectPageProperty extends PageProperty {
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
  MultiSelectPageProperty({this.options = const <MultiSelectOption>[]});

  MultiSelectPageProperty.fromJson(Map<String, dynamic> json, {String? subfield})
      : this.options = MultiSelectOption.fromListJson((subfield != null
            ? json[propertyTypeToString(PropertiesTypes.MultiSelect)][subfield]
            : json[propertyTypeToString(PropertiesTypes.MultiSelect)]) as List),
        super(id: json['id']);

  /// Add a new [option] to the multi select options and returns this instance.
  MultiSelectPageProperty addOption(MultiSelectOption option) {
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
class NumberPageProperty extends PageProperty {
  num? value;

  @override
  final PropertiesTypes type = PropertiesTypes.Number;

  NumberPageProperty(this.value);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.value;

    return json;
  }

  NumberPageProperty.fromJson(Map<String, dynamic> json)
      : this.value = json['number'],
        super(id: json['id']);
}

/// A representation of a number property for any Notion object.
class CheckboxPageProperty extends PageProperty {
  bool value;

  @override
  final PropertiesTypes type = PropertiesTypes.Checkbox;

  CheckboxPageProperty(this.value);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': 'checkbox', 'checkbox': this.value};

    if (this.id != null) {
      json['id'] = this.id;
    }

    return json;
  }

  CheckboxPageProperty.fromJson(Map<String, dynamic> json)
      : this.value = json['checkbox'],
        super(id: json['id']);
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
  final PropertiesTypes type = PropertiesTypes.Date;

  DatePageProperty({required this.startDate});

  // Méthode utilitaire pour formater une date
  String? formatDate(DateTime? date) {
    if (date == null) return null;
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = {"start": formattedStartDate, "end": formattedEndDate, "time_zone": timeZone};

    return json;
  }

  DatePageProperty.fromJson(Map<String, dynamic> json)
      : this.startDate = tryParseDate(json, 'start'),
        this.endDate = tryParseDate(json, 'end'),
        this.timeZone = json['date']?['time_zone'],
        super(id: json['id']);

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
  final PropertiesTypes type = PropertiesTypes.Email;

  EmailPageProperty({required this.email});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.email;

    return json;
  }

  EmailPageProperty.fromJson(Map<String, dynamic> json)
      : this.email = (json['email'] is String) ? json['email'] : "",
        super(id: json['id']);
}

class PhoneNumberPageProperty extends PageProperty {
  String phone;

  @override
  final PropertiesTypes type = PropertiesTypes.PhoneNumber;

  PhoneNumberPageProperty({required this.phone});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.phone;

    return json;
  }

  PhoneNumberPageProperty.fromJson(Map<String, dynamic> json)
      : this.phone = json['phone_number'] ?? "",
        super(id: json['id']);
}

class URLPageProperty extends PageProperty {
  String url;

  @override
  final PropertiesTypes type = PropertiesTypes.URL;

  URLPageProperty({required this.url});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.url;

    return json;
  }

  URLPageProperty.fromJson(Map<String, dynamic> json)
      : this.url = json['url'],
        super(id: json['id']);
}

class SelectPageProperty extends PageProperty {
  String name;
  ColorsTypes color;

  @override
  final PropertiesTypes type = PropertiesTypes.Select;

  SelectPageProperty(this.name, this.color);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.value?.toJson();

    return json;
  }

  SelectPageProperty.fromJson(Map<String, dynamic> json)
      : this.name = json['select']['name'],
        this.color = stringToColorType(json['select']['color'] ?? ''),
        super(id: json['id']);
}

class StatusPageProperty extends PageProperty {
  String name;
  ColorsTypes color;

  @override
  final PropertiesTypes type = PropertiesTypes.Status;

  StatusPageProperty(this.name, this.color);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'type': this.strType};

    if (this.id != null) {
      json['id'] = this.id;
    }

    json[this.strType] = this.value?.toJson();

    return json;
  }

  StatusPageProperty.fromJson(Map<String, dynamic> json)
      : this.name = json['status']['name'],
        this.color = stringToColorType(json['status']['color'] ?? ''),
        super(id: json['id']);
}
