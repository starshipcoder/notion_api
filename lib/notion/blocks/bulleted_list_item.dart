import 'package:notion_api/notion/blocks/block.dart';
import 'package:notion_api/notion/general/rich_text.dart';
import 'package:notion_api/notion/general/types/notion_types.dart';

/// A representation of the Bulleted List Item Notion block object;
class BulletedListItem extends Block {
  /// The block type. Always BulletedListItem.
  @override
  final BlockTypes type = BlockTypes.BulletedListItem;

  List<NotionText> _content = [];
  List<Block> _children = [];

  /// The content of this block.
  List<NotionText> get content => _content.toList();

  /// The children of this block.
  List<Block> get children => _children.toList();

  /// Main bulleted list item constructor.
  ///
  /// Can receive a single [text] or a list of [texts]. If both are included also both fields are added to the heading content adding first the [text] field. Also can receive the [children] of the block.
  BulletedListItem({
    NotionText? text,
    List<NotionText> texts = const [],
    List<Block> children = const [],
  }) {
    if (text != null) {
      _content.add(text);
    }
    _content.addAll(texts);
    _children.addAll(children);
  }

  /// Add a [text] to the rich text array and returns this instance. Also can receive the [annotations] of the text.
  BulletedListItem addText(String text, {TextAnnotations? annotations}) {
    this._content.add(NotionText(text, annotations: annotations));
    return this;
  }

  /// Add a new [block] to the children and returns this instance.
  BulletedListItem addChild(Block block) {
    this._children.add(block);
    return this;
  }

  /// Add a list of [blocks] to the children and returns this instance.
  BulletedListItem addChildren(List<Block> blocks) {
    this._children.addAll(blocks);
    return this;
  }

  /// Convert this to a valid json representation for the Notion API.
  @override
  Map<String, dynamic> toJson() => {
        'object': strObject,
        'type': strType,
        strType: {
          'text': _content.map((e) => e.toJson()).toList(),
          'children': _children.map((e) => e.toJson()).toList(),
        },
      };
}
