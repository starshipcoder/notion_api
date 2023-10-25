/// A wrapper for the public beta Notion API to manage it like a Notion SDK package for dart.
///
/// To see code examples you can go to https://pub.dev/packages/notion_api/example.
///
/// Documentation for Notion API here https://developers.notion.com.
/// API Reference here https://developers.notion.com/reference/intro.
library notion_api;

import 'package:notion_api/statics.dart';

import 'notion_pages.dart';
import 'notion_blocks.dart';
import 'notion_databases.dart';

export 'notion_pages.dart';
export 'notion_blocks.dart';
export 'notion_databases.dart';
export 'package:notion_api/notion/general/properties/database_property.dart';
export 'package:notion_api/notion/general/properties/page_property.dart';
export 'package:notion_api/notion/general/properties/property.dart';
export 'package:notion_api/notion/general/properties/properties.dart';
export 'package:notion_api/notion/objects/pages.dart';
export 'package:notion_api/notion/general/types/notion_types.dart';


/// A Notion API client.
class NotionClient {
  /// The Notion API client for pages requests.
  NotionPagesClient pages;

  /// The Notion API client for databases requests.
  NotionBlockClient blocks;

  /// The Notion API client for databases requests.
  NotionDatabasesClient databases;

  /// Main Notion client constructor.
  ///
  /// Require the [token] to authenticate the requests. Also can receive the API [version] where to make the calls, which is the latests by default (v1); and the [dateVersion] which is by default "2021-05-13" (the latest at 04/07/2021).
  ///
  /// This class is used as the main entry point for all clients. From the instances of this class any other client can be used.
  NotionClient({
    required String token,
    String version = latestVersion,
    String dateVersion = latestDateVersion,
  })  : this.pages = NotionPagesClient(
            token: token, version: version, dateVersion: dateVersion),
        this.databases = NotionDatabasesClient(
            token: token, version: version, dateVersion: dateVersion),
        this.blocks = NotionBlockClient(
            token: token, version: version, dateVersion: dateVersion);
}
