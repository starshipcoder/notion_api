import 'package:notion_api/notion/general/types/notion_types.dart';

// Lists of types
const List<ObjectTypes> objects = ObjectTypes.values;
const List<BlockTypes> blocks = BlockTypes.values;
const List<PropertyType> properties = PropertyType.values;
const List<ColorsTypes> colors = ColorsTypes.values;

/// The heading types.
List<BlockTypes> get headingsTypes => [
      BlockTypes.H1,
      BlockTypes.H2,
      BlockTypes.H3,
    ];

/// Returns the string value of the given block [type].
String blockTypeToString(BlockTypes type) {
  switch (type) {
    case BlockTypes.Unsupported:
      return 'unsupported';
    case BlockTypes.ToDo:
      return 'to_do';
    case BlockTypes.H1:
      return 'heading_1';
    case BlockTypes.H2:
      return 'heading_2';
    case BlockTypes.H3:
      return 'heading_3';
    case BlockTypes.Paragraph:
      return 'paragraph';
    case BlockTypes.BulletedListItem:
      return 'bulleted_list_item';
    case BlockTypes.NumberedListItem:
      return 'numbered_list_item';
    case BlockTypes.Toggle:
      return 'toggle';
    case BlockTypes.Child:
      return 'child_page';
    case BlockTypes.None:
      return '';
  }
}

/// Returns the block type of the given block [type] string.
BlockTypes stringToBlockType(String type) {
  switch (type) {
    case 'heading_1':
      return BlockTypes.H1;
    case 'heading_2':
      return BlockTypes.H2;
    case 'heading_3':
      return BlockTypes.H3;
    case 'paragraph':
      return BlockTypes.Paragraph;
    case 'bulleted_list_item':
      return BlockTypes.BulletedListItem;
    case 'numbered_list_item':
      return BlockTypes.NumberedListItem;
    case 'toogle':
      return BlockTypes.Toggle;
    case 'to_do':
      return BlockTypes.ToDo;
    case 'child_page':
      return BlockTypes.Child;
    case 'unsupported':
      return BlockTypes.Unsupported;
    case '':
    default:
      return BlockTypes.None;
  }
}

/// Returns the string value of the given [color] type.
String colorTypeToString(ColorsTypes color) {
  switch (color) {
    case ColorsTypes.Gray:
      return 'gray';
    case ColorsTypes.Brown:
      return 'brown';
    case ColorsTypes.Orange:
      return 'orange';
    case ColorsTypes.Yellow:
      return 'yellow';
    case ColorsTypes.Green:
      return 'green';
    case ColorsTypes.Blue:
      return 'blue';
    case ColorsTypes.Purple:
      return 'purple';
    case ColorsTypes.Pink:
      return 'pink';
    case ColorsTypes.Red:
      return 'red';
    case ColorsTypes.Default:
      return 'default';
  }
}

/// Returns the color type of the given [color] type string.
ColorsTypes stringToColorType(String color) {
  switch (color) {
    case 'gray':
      return ColorsTypes.Gray;
    case 'brown':
      return ColorsTypes.Brown;
    case 'orange':
      return ColorsTypes.Orange;
    case 'yellow':
      return ColorsTypes.Yellow;
    case 'green':
      return ColorsTypes.Green;
    case 'blue':
      return ColorsTypes.Blue;
    case 'purple':
      return ColorsTypes.Purple;
    case 'pink':
      return ColorsTypes.Pink;
    case 'red':
      return ColorsTypes.Red;
    default:
      return ColorsTypes.Default;
  }
}

/// Returns the string value of the given object [type].
String objectTypeToString(ObjectTypes type) {
  switch (type) {
    case ObjectTypes.Error:
      return 'error';
    case ObjectTypes.Database:
      return 'database';
    case ObjectTypes.List:
      return 'list';
    case ObjectTypes.Page:
      return 'page';
    case ObjectTypes.Object:
      return 'object';
    case ObjectTypes.Block:
      return 'block';
    case ObjectTypes.None:
      return '';
  }
}

/// Returns the object type of the given object [type] string.
ObjectTypes stringToObjectType(String type) {
  switch (type) {
    case 'error':
      return ObjectTypes.Error;
    case 'database':
      return ObjectTypes.Database;
    case 'list':
      return ObjectTypes.List;
    case 'page':
      return ObjectTypes.Page;
    case 'object':
      return ObjectTypes.Object;
    case 'block':
      return ObjectTypes.Block;
    case '':
    default:
      return ObjectTypes.None;
  }
}

/// Returns the string value of the given property [type].
String propertyTypeToString(PropertyType type) {
  switch (type) {
    case PropertyType.RichText:
      return 'rich_text';
    case PropertyType.Number:
      return 'number';
    case PropertyType.Select:
      return 'select';
    case PropertyType.MultiSelect:
      return 'multi_select';
    case PropertyType.Date:
      return 'date';
    case PropertyType.People:
      return 'people';
    case PropertyType.File:
      return 'file';
    case PropertyType.Checkbox:
      return 'checkbox';
    case PropertyType.URL:
      return 'url';
    case PropertyType.Email:
      return 'email';
    case PropertyType.PhoneNumber:
      return 'phone_number';
    case PropertyType.Formula:
      return 'formula';
    case PropertyType.Relation:
      return 'relation';
    case PropertyType.Rollup:
      return 'rollup';
    case PropertyType.CreatedTime:
      return 'created_time';
    case PropertyType.CreatedBy:
      return 'created_by';
    case PropertyType.LastEditedTime:
      return 'last_edited_time';
    case PropertyType.LastEditedBy:
      return 'last_edited_by';
    case PropertyType.Title:
      return 'title';
    case PropertyType.Status:
      return 'status';
    case PropertyType.None:
      return '';
  }
}

/// Returns the property type of the given property [type] string.
PropertyType stringToPropertyType(String type) {
  switch (type) {
    case 'rich_text':
      return PropertyType.RichText;
    case 'number':
      return PropertyType.Number;
    case 'select':
      return PropertyType.Select;
    case 'multi_select':
      return PropertyType.MultiSelect;
    case 'date':
      return PropertyType.Date;
    case 'people':
      return PropertyType.People;
    case 'file':
      return PropertyType.File;
    case 'checkbox':
      return PropertyType.Checkbox;
    case 'url':
      return PropertyType.URL;
    case 'email':
      return PropertyType.Email;
    case 'phone_number':
      return PropertyType.PhoneNumber;
    case 'formula':
      return PropertyType.Formula;
    case 'relation':
      return PropertyType.Relation;
    case 'rollup':
      return PropertyType.Rollup;
    case 'created_time':
      return PropertyType.CreatedTime;
    case 'created_by':
      return PropertyType.CreatedBy;
    case 'last_edited_time':
      return PropertyType.LastEditedTime;
    case 'last_edited_by':
      return PropertyType.LastEditedBy;
    case 'title':
      return PropertyType.Title;
    case 'status':
      return PropertyType.Status;
    case '':
    default:
      return PropertyType.None;
  }
}

/// Returns the string value of the given parent [type].
String parentTypeToString(ParentType type) {
  switch (type) {
    case ParentType.Workspace:
      return 'workspace';
    case ParentType.Database:
      return 'database_id';
    case ParentType.Page:
      return 'page_id';
    case ParentType.None:
      return '';
  }
}

/// Returns the parent type of the given parent [type] string.
ParentType stringToParentType(String type) {
  switch (type) {
    case 'workspace':
      return ParentType.Workspace;
    case 'database_id':
      return ParentType.Database;
    case 'page_id':
      return ParentType.Page;
    case '':
    default:
      return ParentType.None;
  }
}

/// The string values of all properties types.
const List<String> all_str_property_types = [
  'rich_text',
  'number',
  'select',
  'multi_select',
  'date',
  'people',
  'file',
  'checkbox',
  'url',
  'email',
  'phone_number',
  'formula',
  'relation',
  'rollup',
  'created_time',
  'created_by',
  'last_edited_time',
  'last_edited_by',
  'title',
  'status',
];

/// Extract the property type of a [json] property.
///
/// This because sometimes the json response doesn't contain a `type` field but the type can be deduced by the field with the content.
PropertyType extractPropertyType(Map<String, dynamic> json) {
  if (json.keys.contains('type')) {
    return stringToPropertyType(json['type']);
  } else {
    PropertyType type = PropertyType.None;
    json.keys.forEach((key) {
      if (all_str_property_types.contains(key)) {
        type = stringToPropertyType(key);
      }
    });
    return type;
  }
}
