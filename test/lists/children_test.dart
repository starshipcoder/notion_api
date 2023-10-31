import 'package:notion_api/notion/blocks/block.dart';
import 'package:notion_api/notion/blocks/heading.dart';
import 'package:notion_api/notion/blocks/paragraph.dart';
import 'package:notion_api/notion/blocks/todo.dart';
import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/notion/general/rich_text.dart';
import 'package:notion_api/notion/general/lists/children.dart';
import 'package:test/test.dart';

import '../long_data.dart';

void main() {
  group('Children Instance =>', () {
    test('Create new empty instance', () {
      Children children = Children();

      expect(children, isNotNull);
      expect(children.isEmpty, true);
    });

    test('Create new instance with data', () {
      Children children = Children()
          .add(Heading(text: NotionText('A')))
          .add(Paragraph(text: NotionText('B')))
          .add(ToDo(text: NotionText('C')));

      expect(children.isNotEmpty, true);
      expect(children.length, 3);
    });

    test('Create json (for API) from instance', () {
      Map<String, dynamic> children = Children()
          .add(Heading(text: NotionText('A')))
          .add(Paragraph(text: NotionText('B')))
          .add(ToDo(text: NotionText('C')))
          .toJson();

      expect(children['children'], isList);
      expect((children['children'] as List).length, 3);
      expect(((children['children'] as List).first)['type'], 'heading_1');
      expect(((children['children'] as List).last)['type'], 'to_do');
    });

    test('Create instance (from Response) from instance', () {
      Children children =
          Children.fromJson(longBlocksJsonList['results'] as List);

      List<Block> filtered = children.filterBlocks(onlyLeft: BlockTypes.H1);

      expect(children.isNotEmpty, true);
      expect(filtered, isNotEmpty);
      expect(filtered.length, lessThan(children.length));
    });

    test('Filter blocks', () {
      Children children =
          Children.fromJson(longBlocksJsonList['results'] as List);
      List<Block> onlyLeft = children.filterBlocks(onlyLeft: BlockTypes.H1);
      List<Block> exclude = children.filterBlocks(exclude: [BlockTypes.H1]);
      List<Block> include = children.filterBlocks(include: [BlockTypes.H1]);
      List<Block> id =
          children.filterBlocks(id: 'cae15cef-81c1-477b-a3fa-f5d2686db834');

      expect(onlyLeft.length, lessThan(children.length));
      expect(exclude.length, lessThan(children.length));
      expect(include.length, lessThan(children.length));
      expect(include.length, onlyLeft.length);
      expect(id, hasLength(1));
    });

    test('Create json (from Response) from instance', () {
      Map<String, dynamic> children =
          Children.fromJson(longBlocksJsonList['results'] as List).toJson();

      expect(children, isNotNull);
    });

    test('Map from wrong json', () {
      List<dynamic> wrongJsonDatabase = [
        {'foo': 'bar'}
      ];

      Children children = Children.fromJson(wrongJsonDatabase);

      expect(children.isEmpty, true);
    });

    test('Add blocks in distinct ways', () {
      Children deprecated = Children(
        heading: Heading(text: NotionText('Test')),
        paragraph: Paragraph(
          texts: [
            NotionText('Lorem ipsum (A)'),
            NotionText(
              'Lorem ipsum (B)',
              annotations: TextAnnotations(
                bold: true,
                underline: true,
                color: ColorsTypes.orange,
              ),
            ),
          ],
        ),
      );

      Children children1 = Children.withBlocks([
        Heading(text: NotionText('Test')),
        Paragraph(
          texts: [
            NotionText('Lorem ipsum (A)'),
            NotionText(
              'Lorem ipsum (B)',
              annotations: TextAnnotations(
                bold: true,
                underline: true,
                color: ColorsTypes.orange,
              ),
            ),
          ],
        ),
      ]);

      Children children2 =
          Children().add(Heading(text: NotionText('Test'))).add(Paragraph(texts: [
                NotionText('Lorem ipsum (A)'),
                NotionText('Lorem ipsum (B)',
                    annotations: TextAnnotations(
                      bold: true,
                      underline: true,
                      color: ColorsTypes.orange,
                    ))
              ]));

      Children children3 = Children().addAll([
        Heading(text: NotionText('Test')),
        Paragraph(texts: [
          NotionText('Lorem ipsum (A)'),
          NotionText('Lorem ipsum (B)',
              annotations: TextAnnotations(
                bold: true,
                underline: true,
                color: ColorsTypes.orange,
              ))
        ])
      ]);

      var json0 = deprecated.toJson();
      var json1 = children1.toJson();
      var json2 = children2.toJson();
      var json3 = children3.toJson();

      expect(json0, json1);
      expect(json1, json2);
      expect(json2, json3);
    });
  });
}
