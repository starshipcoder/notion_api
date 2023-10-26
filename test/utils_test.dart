import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Utils tests (General)', () {
    test('Get the property type (with type)', () {
      Map<String, dynamic> titleField = {
        'type': 'title',
        'title': {'text': []}
      };
      Map<String, dynamic> richTextField = {
        'type': 'rich_text',
        'rich_text': {'text': []}
      };
      Map<String, dynamic> multiSelectField = {
        'type': 'multi_select',
        'multi_select': []
      };

      PropertyType titleType = extractPropertyType(titleField);
      PropertyType richTextType = extractPropertyType(richTextField);
      PropertyType multiSelectType = extractPropertyType(multiSelectField);

      expect(titleType, PropertyType.Title);
      expect(richTextType, PropertyType.RichText);
      expect(multiSelectType, PropertyType.MultiSelect);
    });

    test('Get the property type (without type)', () {
      Map<String, dynamic> titleField = {
        'title': {'text': []}
      };
      Map<String, dynamic> richTextField = {
        'rich_text': {'text': []}
      };
      Map<String, dynamic> multiSelectField = {'multi_select': []};

      PropertyType titleType = extractPropertyType(titleField);
      PropertyType richTextType = extractPropertyType(richTextField);
      PropertyType multiSelectType = extractPropertyType(multiSelectField);

      expect(titleType, PropertyType.Title);
      expect(richTextType, PropertyType.RichText);
      expect(multiSelectType, PropertyType.MultiSelect);
    });

    test('Get the property type (no type)', () {
      Map<String, dynamic> field = {};
      PropertyType type = extractPropertyType(field);
      expect(type, PropertyType.None);
    });
  });

  group('Utils tests (ObjectTypes) =>', () {
    test('Return an ObjectTypes type', () {
      ObjectTypes type1 = stringToObjectType('invali_string');
      ObjectTypes type2 = stringToObjectType('database');
      ObjectTypes type3 = stringToObjectType('block');
      ObjectTypes type4 = stringToObjectType('error');
      ObjectTypes type5 = stringToObjectType('page');

      expect([type1, type2, type3, type4, type5],
          everyElement(isA<ObjectTypes>()));
      expect(type1, ObjectTypes.None);
      expect(type2, ObjectTypes.Database);
      expect(type3, ObjectTypes.Block);
      expect(type4, ObjectTypes.Error);
      expect(type5, ObjectTypes.Page);
    });

    test('Invalid string return None type', () {
      ObjectTypes type1 = stringToObjectType('invali_string');
      ObjectTypes type2 = stringToObjectType('asdlfknasdkjl');
      ObjectTypes type3 = stringToObjectType('');

      expect([type1, type2, type3], everyElement(ObjectTypes.None));
    });
  });

  group('Utils tests (BlockTypes) =>', () {
    test('Return an ObjectTypes type', () {
      BlockTypes type1 = stringToBlockType('invalid_string');
      BlockTypes type2 = stringToBlockType('heading_2');
      BlockTypes type3 = stringToBlockType('paragraph');
      BlockTypes type4 = stringToBlockType('to_do');
      BlockTypes type5 = stringToBlockType('toogle');

      expect(
          [type1, type2, type3, type4, type5], everyElement(isA<BlockTypes>()));
      expect(type1, BlockTypes.None);
      expect(type2, BlockTypes.H2);
      expect(type3, BlockTypes.Paragraph);
      expect(type4, BlockTypes.ToDo);
      expect(type5, BlockTypes.Toggle);
    });

    test('Invalid string return None type', () {
      BlockTypes type1 = stringToBlockType('invalid_string');
      BlockTypes type2 = stringToBlockType('asdlfknasdkjl');
      BlockTypes type3 = stringToBlockType('');

      expect([type1, type2, type3], everyElement(BlockTypes.None));
    });
  });

  group('Utils tests (PropertiesTypes) =>', () {
    test('Return an ObjectTypes type', () {
      PropertyType type1 = stringToPropertyType('invalid_string');
      PropertyType type2 = stringToPropertyType('title');
      PropertyType type3 = stringToPropertyType('rich_text');
      PropertyType type4 = stringToPropertyType('number');
      PropertyType type5 = stringToPropertyType('select');

      expect([type1, type2, type3, type4, type5],
          everyElement(isA<PropertyType>()));
      expect(type1, PropertyType.None);
      expect(type2, PropertyType.Title);
      expect(type3, PropertyType.RichText);
      expect(type4, PropertyType.Number);
      expect(type5, PropertyType.Select);
    });

    test('Invalid string return None type', () {
      PropertyType type1 = stringToPropertyType('invalid_string');
      PropertyType type2 = stringToPropertyType('asdlfknasdkjl');
      PropertyType type3 = stringToPropertyType('');

      expect([type1, type2, type3], everyElement(PropertyType.None));
    });
  });

  group('(Types to String) || (String to Type tests) =>', () {
    test('Block types', () {
      String strParagraph = blockTypeToString(BlockTypes.Paragraph);
      String strBulleted = blockTypeToString(BlockTypes.BulletedListItem);
      String strNumbered = blockTypeToString(BlockTypes.NumberedListItem);
      String strToogle = blockTypeToString(BlockTypes.Toggle);
      String strChild = blockTypeToString(BlockTypes.Child);

      expect(strParagraph, 'paragraph');
      expect(strBulleted, 'bulleted_list_item');
      expect(strNumbered, 'numbered_list_item');
      expect(strToogle, 'toggle');
      expect(strChild, 'child_page');
    });

    test('None types', () {
      String propertyType = propertyTypeToString(PropertyType.None);
      String blockType = blockTypeToString(BlockTypes.None);
      String objectType = objectTypeToString(ObjectTypes.None);
      String parentType = parentTypeToString(ParentType.None);
      expect([propertyType, blockType, objectType, parentType],
          everyElement(isEmpty));
    });

    test('Page types', () {
      String page = parentTypeToString(ParentType.Page);
      expect(page, 'page_id');
    });
  });
}
