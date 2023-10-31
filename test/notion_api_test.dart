import 'dart:io' show Platform;

import 'package:dotenv/dotenv.dart' show load, env, clean;
import 'package:notion_api/notion/blocks/bulleted_list_item.dart';
import 'package:notion_api/notion/blocks/heading.dart';
import 'package:notion_api/notion/blocks/numbered_list_item.dart';
import 'package:notion_api/notion/blocks/paragraph.dart';
import 'package:notion_api/notion/blocks/todo.dart';
import 'package:notion_api/notion/blocks/toggle.dart';
import 'package:notion_api/notion/general/lists/children.dart';
import 'package:notion_api/notion.dart';
import 'package:notion_api/notion/objects/parent.dart';
import 'package:notion_api/responses/notion_response.dart';
import 'package:test/test.dart';

void main() {
  String? token = Platform.environment['TOKEN'];
  String? testDatabaseId = Platform.environment['TEST_DATABASE_ID'];
  String? testPageId = Platform.environment['TEST_PAGE_ID'];
  String? testBlockId = Platform.environment['TEST_BLOCK_ID'];

  String execEnv = env['EXEC_ENV'] ?? Platform.environment['EXEC_ENV'] ?? '';
  if (execEnv != 'github_actions') {
    setUpAll(() {
      load();

      token = env['TOKEN'] ?? token ?? '';
      testDatabaseId = env['TEST_DATABASE_ID'] ?? testDatabaseId ?? '';
      testPageId = env['TEST_PAGE_ID'] ?? testPageId ?? '';
      testBlockId = env['TEST_BLOCK_ID'] ?? testBlockId ?? '';
    });

    tearDownAll(() {
      clean();
    });
  }

  group('Notion Client', () {
    test('Retrieve a page', () async {
      final NotionClient notion = NotionClient(token: token ?? '');
      NotionResponse res = await notion.pages.fetch(testPageId ?? '');

      expect(res.status, 200);
      expect(res.isPage, true);
      expect(res.content, isNotNull);
      expect(res.content, isA<NotionPage>());
      expect(res.isOk, true);
    });
  });

  group('Notion Pages Client =>', () {
    test('Create a page', () async {
      final NotionPagesClient pages = NotionPagesClient(token: token ?? '');

      final NotionPage page = NotionPage(
        parent: Parent.database(id: testDatabaseId ?? ''),
        title: NotionText('NotionClient (v1): Page test'),
      );

      var res = await pages.create(page);

      expect(res.status, 200);
    });

    test('Create a page with default title', () async {
      final NotionPagesClient pages = NotionPagesClient(token: token ?? '');

      final NotionPage page = NotionPage(
        parent: Parent.database(id: testDatabaseId ?? ''),
      );

      var res = await pages.create(page);

      expect(res.status, 200);
    });

    test('Create a page with full example', () async {
      Children fullContent = Children.withBlocks([
        Heading(text: NotionText('This the title')),
        Paragraph(texts: [
          NotionText(
            'Here you can write all the content of the paragraph but if you want to have another style for a single word you will have to do ',
          ),
          NotionText(
            'this. ',
            annotations: TextAnnotations(
              color: ColorsTypes.green,
              bold: true,
              italic: true,
            ),
          ),
          NotionText(
            'Then you can continue writing all your content. See that if you separate the paragraph to stylized some parts you have to take in count the spaces because the ',
          ),
          NotionText('textSeparator', annotations: TextAnnotations(code: true)),
          NotionText(
              ' will be deprecated. Maybe you will see this with extra spaces because the separator but soon will be remove.')
        ], children: [
          Heading(
            text: NotionText('This is a subtitle for the paragraph'),
            type: 2,
          ),
          Paragraph(texts: [
            NotionText(
              'You can also have children for some blocks like ',
            ),
            NotionText(
              'Paragraph',
              annotations: TextAnnotations(code: true),
            ),
            NotionText(', '),
            NotionText(
              'ToDo',
              annotations: TextAnnotations(code: true),
            ),
            NotionText(', '),
            NotionText(
              'BulletedListItems',
              annotations: TextAnnotations(code: true),
            ),
            NotionText(' or '),
            NotionText(
              'NumberedListItems',
              annotations: TextAnnotations(code: true),
            ),
            NotionText('.'),
          ]),
          Paragraph(
            text: NotionText(
              'Also, if your paragraph will have the same style you can write all your text directly like this to avoid using a list.',
            ),
          ),
        ]),
        Heading(text: NotionText('Blocks'), type: 2),
        Heading(text: NotionText('ToDo'), type: 3),
        ToDo(text: NotionText('Daily meeting'), checked: true),
        ToDo(text: NotionText('Clean the house')),
        ToDo(text: NotionText('Do the laundry')),
        ToDo(text: NotionText('Call mom'), children: [
          Paragraph(texts: [
            NotionText('Note: ', annotations: TextAnnotations(bold: true)),
            NotionText('Remember to call her before 20:00'),
          ]),
        ]),
        Heading(text: NotionText('Lists'), type: 3),
        BulletedListItem(text: NotionText('Milk')),
        BulletedListItem(text: NotionText('Cereal')),
        BulletedListItem(text: NotionText('Eggs')),
        BulletedListItem(text: NotionText('Tortillas of course')),
        Paragraph(
          text: NotionText('The numbered list are ordered by default by notion.'),
        ),
        NumberedListItem(text: NotionText('Notion')),
        NumberedListItem(text: NotionText('Keep by Google')),
        NumberedListItem(text: NotionText('Evernote')),
        Heading(text: NotionText('Toggle'), type: 3),
        Toggle(text: NotionText('Toogle items'), children: [
          Paragraph(
            text: NotionText(
              'Toogle items are blocks that can show or hide their children, and their children can be any other block.',
            ),
          ),
        ])
      ]);

      final NotionClient notion = NotionClient(token: token ?? '');

      final NotionPage page = NotionPage(
        parent: Parent.database(id: testDatabaseId ?? ''),
        title: NotionText('notion_api example'),
      );

      var newPage = await notion.pages.create(page);

      String newPageId = newPage.page!.id;

      var res = await notion.blocks.append(
        to: newPageId,
        children: fullContent,
      );

      expect(res.status, 200);
    });

    test('Update a page (properties)', () async {
      final NotionPagesClient pages = NotionPagesClient(token: token ?? '');

      var res = await pages.update('15db928d5d2a43ada59e3136663d41f6',
          properties: PageProperties(map: {
            'Property': RichTextPageProperty(content: [NotionText('A')])
          }));

      expect(res.status, 200);
    });

    test('Update a page (archived)', () async {
      final NotionPagesClient pages = NotionPagesClient(token: token ?? '');

      var res = await pages.update('15db928d5d2a43ada59e3136663d41f6',
          archived: false);

      expect(res.status, 200);
    });
  });

  group('Notion Databases Client =>', () {
    test('Retrieve a database', () async {
      final NotionDatabasesClient databases =
          NotionDatabasesClient(token: token ?? '');

      NotionResponse res = await databases.fetch(testDatabaseId ?? '');

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Retrieve all databases', () async {
      final NotionDatabasesClient databases =
          NotionDatabasesClient(token: token ?? '');

      NotionResponse res = await databases.fetchAll();

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Retrieve all databases with wrong query', () async {
      final NotionDatabasesClient databases =
          NotionDatabasesClient(token: token ?? '');

      NotionResponse res = await databases.fetchAll(startCursor: '');

      expect(res.status, 400);
      expect(res.code, 'validation_error');
      expect(res.isOk, false);
      expect(res.isError, true);
    });

    test('Retrieve all databases with query', () async {
      final NotionDatabasesClient databases =
          NotionDatabasesClient(token: token ?? '');

      const int limit = 2;
      NotionResponse res = await databases.fetchAll(pageSize: limit);

      expect(res.isOk, true);
      expect(res.isList, true);
      expect(res.content.length, lessThanOrEqualTo(limit));
    });

    test('Create a database', () async {
      final NotionDatabasesClient databases =
          NotionDatabasesClient(token: token ?? '');

      NotionResponse res = await databases.create(Database.newDatabase(
        parent: Parent.page(id: testPageId ?? ''),
        title: [
          NotionText('Database from test'),
        ],
        pagesColumnName: 'Custom pages column',
        properties: DatabaseProperties(map: {
          'Description': MultiSelectDatabaseProperty(options: [
            MultiSelectOption(name: 'Read', color: ColorsTypes.blue),
            MultiSelectOption(name: 'Sleep', color: ColorsTypes.green),
          ])
        }),
      ));

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Create a database with default', () async {
      final NotionDatabasesClient databases =
          NotionDatabasesClient(token: token ?? '');

      NotionResponse res = await databases.create(Database.newDatabase(
        parent: Parent.page(id: testPageId ?? ''),
      ));

      expect(res.status, 200);
      expect(res.isOk, true);
    });
  });

  group('Notion Block Client =>', () {
    test('Retrieve block children', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      NotionResponse res = await blocks.fetch(testBlockId ?? '');

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Retrieve block children with wrong query', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      NotionResponse res =
          await blocks.fetch(testBlockId ?? '', startCursor: '');

      expect(res.status, 400);
      expect(res.code, 'validation_error');
      expect(res.isOk, false);
      expect(res.isError, true);
    });

    test('Retrieve block children with query', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      const int limit = 2;
      NotionResponse res =
          await blocks.fetch(testBlockId ?? '', pageSize: limit);

      expect(res.isOk, true);
      expect(res.isList, true);
      expect(res.content.length, lessThanOrEqualTo(limit));
    });

    test('Append complex stuff', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      NotionResponse res = await blocks.append(
        to: testBlockId as String,
        children: Children.withBlocks([
          Heading(text: NotionText('This the title')),
          Paragraph(texts: [
            NotionText(
              'Here you can write all the content of the paragraph but if you want to have another style for a single word you will have to do ',
            ),
            NotionText(
              'this. ',
              annotations: TextAnnotations(
                color: ColorsTypes.green,
                bold: true,
                italic: true,
              ),
            ),
            NotionText(
              'Then you can continue writing all your content. See that if you separate the paragraph to stylized some parts you have to take in count the spaces because the ',
            ),
            NotionText('textSeparator', annotations: TextAnnotations(code: true)),
            NotionText(
                ' will be deprecated. Maybe you will see this with extra spaces because the separator but soon will be remove.')
          ], children: [
            Heading(
              text: NotionText('This is a subtitle for the paragraph'),
              type: 2,
            ),
            Paragraph(texts: [
              NotionText(
                'You can also have children for some blocks like ',
              ),
              NotionText(
                'Paragraph',
                annotations: TextAnnotations(code: true),
              ),
              NotionText(', '),
              NotionText(
                'ToDo',
                annotations: TextAnnotations(code: true),
              ),
              NotionText(', '),
              NotionText(
                'BulletedListItems',
                annotations: TextAnnotations(code: true),
              ),
              NotionText(' or '),
              NotionText(
                'NumberedListItems',
                annotations: TextAnnotations(code: true),
              ),
              NotionText('.'),
            ]),
            Paragraph(
              text: NotionText(
                'Also, if your paragraph will have the same style you can write all your text directly like this to avoid using a list.',
              ),
            ),
          ]),
          Heading(text: NotionText('Blocks'), type: 2),
          Heading(text: NotionText('ToDo'), type: 3),
          ToDo(text: NotionText('Daily meeting'), checked: true),
          ToDo(text: NotionText('Clean the house')),
          ToDo(text: NotionText('Do the laundry')),
          ToDo(text: NotionText('Call mom'), children: [
            Paragraph(texts: [
              NotionText('Note: ', annotations: TextAnnotations(bold: true)),
              NotionText('Remember to call her before 20:00'),
            ]),
          ]),
          Heading(text: NotionText('Lists'), type: 3),
          BulletedListItem(text: NotionText('Milk')),
          BulletedListItem(text: NotionText('Cereal')),
          BulletedListItem(text: NotionText('Eggs')),
          BulletedListItem(text: NotionText('Tortillas of course')),
          Paragraph(
            text: NotionText('The numbered list are ordered by default by notion.'),
          ),
          NumberedListItem(text: NotionText('Notion')),
          NumberedListItem(text: NotionText('Keep by Google')),
          NumberedListItem(text: NotionText('Evernote')),
          Heading(text: NotionText('Toggle'), type: 3),
          Toggle(text: NotionText('Toogle items'), children: [
            Paragraph(
              text: NotionText(
                'Toogle items are blocks that can show or hide their children, and their children can be any other block.',
              ),
            ),
          ])
        ]),
      );

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Append heading & text', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      NotionResponse res = await blocks.append(
        to: testBlockId as String,
        children: Children.withBlocks([
          Heading(text: NotionText('Test')),
          Paragraph(texts: [
            NotionText('Lorem ipsum (A)'),
            NotionText(
              'Lorem ipsum (B)',
              annotations: TextAnnotations(
                bold: true,
                underline: true,
                color: ColorsTypes.orange,
              ),
            ),
          ], children: [
            Heading(text: NotionText('Subtitle'), type: 3),
          ]),
        ]),
      );

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Append todo block', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      NotionResponse res = await blocks.append(
        to: testBlockId as String,
        children: Children.withBlocks([
          ToDo(text: NotionText('This is a todo item A')),
          ToDo(
            texts: [
              NotionText('This is a todo item'),
              NotionText(
                'B',
                annotations: TextAnnotations(bold: true),
              ),
            ],
          ),
          ToDo(text: NotionText('Todo item with children'), children: [
            BulletedListItem(text: NotionText('A')),
            BulletedListItem(text: NotionText('B')),
          ])
        ]),
      );

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Append bulleted list item block', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      NotionResponse res = await blocks.append(
        to: testBlockId as String,
        children: Children.withBlocks(
          [
            BulletedListItem(text: NotionText('This is a bulleted list item A')),
            BulletedListItem(text: NotionText('This is a bulleted list item B')),
            BulletedListItem(
              text: NotionText('This is a bulleted list item with children'),
              children: [
                Paragraph(texts: [
                  NotionText('A'),
                  NotionText('B'),
                  NotionText('C'),
                ])
              ],
            ),
          ],
        ),
      );

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Colors', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');
      NotionResponse res = await blocks.append(
        to: testBlockId as String,
        children: Children.withBlocks(
          [
            Paragraph(
              texts: [
                NotionText(
                  'gray',
                  annotations: TextAnnotations(color: ColorsTypes.gray),
                ),
                NotionText(
                  'brown',
                  annotations: TextAnnotations(color: ColorsTypes.brown),
                ),
                NotionText(
                  'orange',
                  annotations: TextAnnotations(color: ColorsTypes.orange),
                ),
                NotionText(
                  'yellow',
                  annotations: TextAnnotations(color: ColorsTypes.yellow),
                ),
                NotionText(
                  'green',
                  annotations: TextAnnotations(color: ColorsTypes.green),
                ),
                NotionText(
                  'blue',
                  annotations: TextAnnotations(color: ColorsTypes.blue),
                ),
                NotionText(
                  'purple',
                  annotations: TextAnnotations(color: ColorsTypes.purple),
                ),
                NotionText(
                  'pink',
                  annotations: TextAnnotations(color: ColorsTypes.pink),
                ),
                NotionText(
                  'red',
                  annotations: TextAnnotations(color: ColorsTypes.red),
                ),
                NotionText(
                  'default',
                  annotations: TextAnnotations(color: ColorsTypes.default_),
                ),
              ],
            ),
          ],
        ),
      );

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Append numbered list item block', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      NotionResponse res = await blocks.append(
        to: testBlockId as String,
        children: Children.withBlocks(
          [
            NumberedListItem(text: NotionText('This is a numbered list item A')),
            NumberedListItem(text: NotionText('This is a numbered list item B')),
            NumberedListItem(
              text: NotionText('This is a bulleted list item with children'),
              children: [
                Paragraph(texts: [
                  NotionText(
                    'This paragraph start with color gray ',
                    annotations: TextAnnotations(color: ColorsTypes.gray),
                  ),
                  NotionText(
                    'and end with brown',
                    annotations: TextAnnotations(color: ColorsTypes.brown),
                  ),
                ])
              ],
            ),
          ],
        ),
      );

      expect(res.status, 200);
      expect(res.isOk, true);
    });

    test('Append toggle block', () async {
      final NotionBlockClient blocks = NotionBlockClient(token: token ?? '');

      NotionResponse res = await blocks.append(
        to: testBlockId as String,
        children: Children.withBlocks(
          [
            Toggle(
              text: NotionText('This is a toggle block'),
              children: [
                Paragraph(
                  texts: [
                    NotionText(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas venenatis dolor sed ex egestas, et vehicula tellus faucibus. Sed pellentesque tellus eget imperdiet vulputate.')
                  ],
                ),
                BulletedListItem(text: NotionText('A')),
                BulletedListItem(text: NotionText('B')),
                BulletedListItem(text: NotionText('B')),
              ],
            ),
          ],
        ),
      );

      expect(res.status, 200);
      expect(res.isOk, true);
    });
  });
}
