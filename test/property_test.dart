import 'package:notion_api/notion.dart';
import 'package:notion_api/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Main property =>', () {
    test('Create an instance of property', () {
      PageProperty prop = PageProperty.empty();
      expect(prop.type, PropertyType.None);
      expect(prop.value, false);
    });

    test('Create a json from empty property', () {
      PageProperty prop = PageProperty.empty();
      expect(() => prop.toJson(), throwsA(isA<String>()));
    });

    test('Create a property from json', () {
      PageProperty prop = PageProperty.propertyFromJson(
          {"id": "title", "type": "title", "title": {}});

      expect(prop.isTitle, true);
      expect(prop.type, PropertyType.Title);
      expect(prop.strType, propertyTypeToString(PropertyType.Title));
    });

    test('Create a properties map from json', () {
      Map<String, PageProperty> json = PageProperty.propertiesFromJson({
        "Tags": {
          "id": ">cp;",
          "type": "multi_select",
          "multi_select": {"options": []}
        },
        "Name": {
          "id": "title",
          "type": "title",
          "title": {},
        },
        "Details": {
          'id': 'D[X|',
          'type': 'rich_text',
          "rich_text": [
            {
              "type": "text",
              "text": {"content": "foo bar"}
            }
          ]
        },
        "Quantity": {
          "number": 1234,
        }
      });

      expect(json, isNotEmpty);
      expect(json, contains('Tags'));
      expect(json['Tags']!.isMultiSelect, true);
      expect(json, contains('Name'));
      expect(json['Name']!.isTitle, true);
      expect(json, contains('Details'));
      expect(json['Details']!.isRichText, true);
      expect(json, contains('Quantity'));
      expect(json['Quantity']!.strType, 'number');
      expect(json['Quantity']!.value, 1234);
    });

    test('Create json from Property inherited class', () {
      Property prop = TitlePageProperty(content: [NotionText('Title')]);
      Map<String, dynamic> json = prop.toJson();

      String strType = propertyTypeToString(PropertyType.Title);
      expect(json['type'], strType);
      expect(json, contains(strType));
      expect((json[strType] as List).length, 1);
    });

    test('Check if property is empty', () {
      bool isEmptyTrue = Property.isEmpty(
          {'id': 'title', 'type': 'title', 'title': []}, PropertyType.Title);
      bool isEmptyFalse = Property.isEmpty({
        'id': 'title',
        'type': 'title',
        'title': [
          {
            "type": "text",
            "text": {"content": "Page from Test", "link": null},
            "annotations": {
              "bold": false,
              "italic": false,
              "strikethrough": false,
              "underline": false,
              "code": false,
              "color": "default"
            },
            "plain_text": "Page from Test",
            "href": null
          }
        ]
      }, PropertyType.Title);
      expect(isEmptyTrue, true);
      expect(isEmptyFalse, false);
    });
  });

  group('Title property =>', () {
    test('Create an instance of property', () {
      TitlePageProperty prop = TitlePageProperty(content: [NotionText('TITLE')]);

      expect(prop.type, PropertyType.Title);
      expect(prop.content, isNotEmpty);
      expect(prop.content.length, 1);
    });

    test('Create a json from property', () {
      Map<String, dynamic> json = TitlePageProperty(content: [NotionText('TITLE')]).toJson();

      String strType = propertyTypeToString(PropertyType.Title);
      expect(json['type'], strType);
      expect(json, contains(strType));
      expect((json[strType] as List).length, 1);
    });
  });

  group('RichText property =>', () {
    test('Create an instance of property', () {
      RichTextPageProperty rich = RichTextPageProperty(content: [NotionText('A'), NotionText('B')]);

      expect(rich.type, PropertyType.RichText);
      expect(rich.content, isNotEmpty);
      expect(rich.content.length, 2);
      expect(rich.value, isNotEmpty);
      expect(rich.value.length, 2);
    });
    test('Create a json from property', () {
      Map<String, dynamic> json =
      RichTextPageProperty(content: [NotionText('A'), NotionText('B')]).toJson();

      String strType = propertyTypeToString(PropertyType.RichText);
      expect(json['type'], strType);
      expect(json, contains(strType));
      expect((json[strType] as List).length, 2);
    });
  });

  group('MultiSelect property =>', () {
    test('Create an instance of property', () {
      MultiSelectPageProperty multi =
      MultiSelectPageProperty(options: [MultiSelectOption(name: 'A')]);

      expect(multi.type, PropertyType.MultiSelect);
      expect(multi.options, isNotEmpty);
      expect(multi.options.length, 1);
    });

    test('Create an instance with mixed options', () {
      MultiSelectPageProperty multi =
      MultiSelectPageProperty(options: [MultiSelectOption(name: 'A')])
              .addOption(MultiSelectOption(name: 'B'))
              .addOption(MultiSelectOption(name: 'C'));

      expect(multi.type, PropertyType.MultiSelect);
      expect(multi.options, hasLength(3));
      expect(multi.options.first.name, 'A');
      expect(multi.options.last.name, 'C');
    });

    test('Create an option for multi select', () {
      MultiSelectOption option = MultiSelectOption(name: 'A');

      expect(option.name, 'A');
      expect(option.id, isNull);
      expect(option.color, ColorsTypes.default_);
    });

    test('Create an option from json', () {
      Map<String, dynamic> json = {'name': 'A', 'color': 'brown'};
      MultiSelectOption option = MultiSelectOption.fromJson(json);

      expect(option.name, 'A');
      expect(option.id, isNull);
      expect(option.color, ColorsTypes.brown);
    });

    test('Create a json from property', () {
      Map<String, dynamic> json =
          MultiSelectPageProperty(options: [MultiSelectOption(name: 'A')]).toJson();

      String strType = propertyTypeToString(PropertyType.MultiSelect);
      expect(json['type'], strType);
      expect(json, contains(strType));
      expect(json[strType], contains('options'));
      expect(json[strType]['options'], isList);
      expect(json[strType]['options'], isNotEmpty);
    });

    test('Create a json from option without id', () {
      Map<String, dynamic> json =
          MultiSelectOption(name: 'A', color: ColorsTypes.brown).toJson();

      expect(json['name'], 'A');
      expect(json['id'], isNull);
      expect(json['color'], contains(colorTypeToString(ColorsTypes.brown)));
    });

    test('Create a json from option with id', () {
      Map<String, dynamic> json =
          MultiSelectOption(name: 'A', color: ColorsTypes.brown, id: 'a')
              .toJson();

      expect(json['name'], 'A');
      expect(json['id'], isNotNull);
      expect(json['color'], contains(colorTypeToString(ColorsTypes.brown)));
    });

    test('Create an options list from json', () {
      List<MultiSelectOption> list = MultiSelectOption.fromListJson([
        {'name': 'A', 'id': 'a'},
        {'name': 'B', 'id': 'b'},
      ]);

      expect(list, isNotEmpty);
      expect(list.length, 2);
    });
  });

  group('Property response =>', () {
    Map<String, dynamic> json = {
      "id": "title",
      "type": "title",
      "title": [
        {
          "type": "text",
          "text": {"content": "Page from Test", "link": null},
          "annotations": {
            "bold": false,
            "italic": false,
            "strikethrough": false,
            "underline": false,
            "code": false,
            "color": "default"
          },
          "plain_text": "Page from Test",
          "href": null
        }
      ]
    };

    Map<String, dynamic> jsonDetails = {
      'id': 'D[X|',
      'type': 'rich_text',
      "rich_text": [
        {
          "type": "text",
          "text": {"content": "Some more text with "}
        },
        {
          "type": "text",
          "text": {"content": "some"},
          "annotations": {"italic": true}
        },
        {
          "type": "text",
          "text": {"content": " "}
        },
        {
          "type": "text",
          "text": {"content": "formatting"},
          "annotations": {"color": "pink"}
        }
      ]
    };
    Map<String, dynamic> jsonMultiSelectWithoutSubfield = {
      "id": ">cp;",
      "type": "multi_select",
      "multi_select": [
        {"name": "B"},
        {"name": "C"}
      ]
    };
    Map<String, dynamic> jsonMultiSelectWithSubfield = {
      "id": ">cp;",
      "type": "multi_select",
      "multi_select": {
        "options": [
          {"name": "B"},
          {"name": "C"}
        ]
      }
    };
    test('Map name from json response', () {
      TitlePageProperty prop = TitlePageProperty.fromJson(json);

      expect(prop.content, isNotEmpty);
    });

    test('Create json from name json response', () {
      Map<String, dynamic> jsonTest = TitlePageProperty.fromJson(json).toJson();

      String strType = propertyTypeToString(PropertyType.Title);
      expect(jsonTest['type'], strType);
      expect(jsonTest, contains(strType));
      expect(jsonTest[strType], isList);
    });

    test('Map details from json response', () {
      RichTextPageProperty prop = RichTextPageProperty.fromJson(jsonDetails);

      expect(prop.content, isNotEmpty);
      expect(prop.content.length, 4);
    });

    test('Create json from details json response', () {
      Map<String, dynamic> jsonTest =
      RichTextPageProperty.fromJson(jsonDetails).toJson();

      String strType = propertyTypeToString(PropertyType.RichText);
      expect(jsonTest['type'], strType);
      expect(jsonTest['id'], isNotNull);
      expect(jsonTest, contains(strType));
      expect(jsonTest[strType], isList);
    });

    test('Map tag from json response without options subfield', () {
      MultiSelectPageProperty multi =
      MultiSelectPageProperty.fromJson(jsonMultiSelectWithoutSubfield);

      expect(multi.options, isNotEmpty);
    });

  });
}
