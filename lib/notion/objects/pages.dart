import 'package:notion_api/notion.dart';
import 'package:notion_api/notion/general/base_fields.dart';
import 'package:notion_api/notion/general/lists/children.dart';

import 'parent.dart';

/// A representation of the Page Notion object.
class NotionPage extends BaseFields {
  /// The type of this object. Always Page for this.
  @override
  final ObjectTypes object = ObjectTypes.Page;

  /// The information of the page parent.
  Parent parent;

  /// The field that defined if is archived or not.
  bool archived;

  NotionIcon icon;

  String url;

  /// The content of the page.
  Children? children;

  /// The properties of the page.
  final PageProperties properties = PageProperties();

  /// Main constructor for the page.
  ///
  /// This constructor require the [parent] and can
  /// receive if is [archived] and his [children].
  /// Also the [id] of the page and the [title].
  ///
  /// The [children] and [title] fields are defined
  /// for when a new page is created.
  NotionPage({
    required this.parent,
    this.icon = const NotionIcon(type: IconType.none),
    this.url = '',
    this.archived = false,
    this.children,
    String id = '',
    NotionText? title,
  }) {
    this.id = id;
    if (title != null) {
      this.title = title;
    }
    if (this.children == null) {
      this.children = Children();
    }
  }

  /// Constructor for empty page.
  NotionPage.empty()
      : this.parent = Parent.none(),
        this.archived = false,
        this.icon = const NotionIcon(),
        this.url = '',
        super();

  /// Contructor from json.
  factory NotionPage.fromJson(Map<String, dynamic> json) {
    NotionPage page = NotionPage(
      id: json['id'] ?? '',
      parent: Parent.fromJson(json['parent'] ?? {}),
      archived: json['archived'] ?? false,
      icon: NotionIcon.fromJson(json['icon'] ?? {}),
      url: json['url'] ?? '',
    ).addPropertiesFromJson(json['properties'] ?? {});
    page.setBaseProperties(
        createdTime: json['created_time'] ?? '',
        lastEditedTime: json['last_edited_time'] ?? '');
    return page;
  }

  /// Set the [title] of the page.
  set title(NotionText title) {
    // Only set one title at a time.
    if (this.properties.contains('title')) {
      this.properties.remove('title');
    }

    this.properties.add(name: 'title', property: TitlePageProperty(propName: 'title', id: '', content: [title]));
  }

  /// Add a [property] with a specific [name] to this properties.
  NotionPage addProperty({required String name, required PageProperty property}) {
    this.properties.add(name: name, property: property);
    return this;
  }

  /// Add a multiples properties from a [json] to this properties.
  NotionPage addPropertiesFromJson(Map<String, dynamic> json) {
    this.properties.addAllFromJson(json);
    return this;
  }

  /// Convert this to a json representation valid for the Notion API.
  Map<String, dynamic> toJson({bool isResponse = false}) {
    Map<String, dynamic> json = {
      'parent': this.parent.toJson(),
      'properties': this.properties.toJson(),
    };

    // Add response json fields.
    if (isResponse) {
      json['object'] = strObject;
      json['id'] = id;
      json['created_time'] = createdTime;
      json['last_edited_time'] = lastEditedTime;
      json['archived'] = archived;
    }

    // Only add children to json if have items.
    if (this.children != null && this.children!.isNotEmpty) {
      json['children'] = this.children!.toJson();
    }

    return json;
  }
}
