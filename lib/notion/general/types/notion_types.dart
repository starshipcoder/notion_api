/// The basic notion types.
enum BlockTypes {
  None,
  H1,
  H2,
  H3,
  Paragraph,
  BulletedListItem,
  NumberedListItem,
  ToDo,
  Toggle,
  Child,
  Unsupported,
}

/// The notion objects types.
enum ObjectTypes {
  None,
  Database,
  Block,
  Object,
  Page,
  List,
  Error,
}

/// The notion objects properties types.
enum PropertyType {
  None,
  Title,
  RichText,
  Number,
  Select,
  MultiSelect,
  Date,
  People,
  File,
  Checkbox,
  URL,
  Email,
  PhoneNumber,
  Formula,
  Relation,
  Rollup,
  CreatedTime,
  CreatedBy,
  LastEditedTime,
  LastEditedBy,
  Status,
}

/// The basic colors.
enum ColorsTypes {
  gray,
  brown,
  orange,
  yellow,
  green,
  blue,
  purple,
  pink,
  red,
  default$,
}

/// The parent types for pages objects.
enum ParentType {
  None,
  Workspace,
  Database,
  Page,
}
