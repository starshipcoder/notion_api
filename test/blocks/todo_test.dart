import 'package:notion_api/notion/blocks/heading.dart';
import 'package:notion_api/notion/blocks/paragraph.dart';
import 'package:notion_api/notion/blocks/todo.dart';
import 'package:notion_api/notion/general/rich_text.dart';
import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('ToDo tests =>', () {
    test('Create an empty instance', () {
      ToDo todo = ToDo();

      expect(todo, isNotNull);
      expect(todo.strType, blockTypeToString(BlockTypes.ToDo));
      expect(todo.content, allOf([isList, isEmpty]));
      expect(todo.checked, false);
      expect(todo.isToDo, true);
      expect(todo.type, BlockTypes.ToDo);
    });

    test('Create an instance with information', () {
      ToDo todo = ToDo(text: NotionText('A'), checked: true).addText('B');

      expect(todo.checked, true);
      expect(todo.content.length, 2);
      expect(todo.content.first.text, 'A');
      expect(todo.content.last.text, 'B');
    });

    test('Create an instance with mixed information', () {
      ToDo todo = ToDo(
        text: NotionText('first'),
        texts: [
          NotionText('foo'),
          NotionText('bar'),
        ],
        checked: true,
      ).addText('last').addChild(Paragraph(texts: [
            NotionText('A'),
            NotionText('B'),
          ]));

      expect(todo.checked, true);
      expect(todo.content.length, 4);
      expect(todo.content.first.text, 'first');
      expect(todo.content.last.text, 'last');
      expect(todo.children.length, 1);
    });

    test('Create an instance with children', () {
      ToDo todo = ToDo(
        text: NotionText('todo'),
        checked: true,
      ).addChildren([
        Heading(
          text: NotionText(
            'Subtitle',
            annotations: TextAnnotations(color: ColorsTypes.Green),
          ),
        ),
        Paragraph(
          texts: [
            NotionText('A'),
            NotionText('B'),
          ],
        ),
      ]);

      expect(todo.checked, true);
      expect(todo.content.length, 1);
      expect(todo.children.length, 2);
    });

    test('Create json from instance', () {
      Map<String, dynamic> json = ToDo(text: NotionText('A'))
          .addChild(Paragraph(texts: [
            NotionText('A'),
            NotionText('B'),
          ]))
          .toJson();

      expect(json['type'],
          allOf([isNotNull, isNotEmpty, blockTypeToString(BlockTypes.ToDo)]));
      expect(json, contains(blockTypeToString(BlockTypes.ToDo)));
      expect(json[blockTypeToString(BlockTypes.ToDo)]['text'],
          allOf([isList, isNotEmpty]));
      expect(json[blockTypeToString(BlockTypes.ToDo)]['children'],
          allOf([isList, isNotEmpty]));
    });

    test('Create json from empty instance', () {
      Map<String, dynamic> json = ToDo().toJson();

      expect(json['type'],
          allOf([isNotNull, isNotEmpty, blockTypeToString(BlockTypes.ToDo)]));
      expect(json, contains(blockTypeToString(BlockTypes.ToDo)));
      expect(json[blockTypeToString(BlockTypes.ToDo)]['text'],
          allOf([isList, isEmpty]));
      expect(json[blockTypeToString(BlockTypes.ToDo)]['children'],
          allOf([isList, isEmpty]));
    });
  });
}
