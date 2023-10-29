import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notion_api/base_client.dart';
import 'package:notion_api/notion/objects/database.dart';
import 'package:notion_api/notion/query/notion_sort.dart';

import 'responses/notion_response.dart';
import 'statics.dart';

/// A client for Notion API databases requests.
class NotionDatabasesClient extends BaseClient {
  /// The path of the requests group.
  @override
  final String path = 'databases';

  /// Main Notion database client constructor.
  ///
  /// Require the [token] to authenticate the requests, and the API [version] where to make the calls, which is the latests by default (v1).
  NotionDatabasesClient({
    required String token,
    String version = latestVersion,
    String dateVersion = latestDateVersion,
  }) : super(token: token, version: version, dateVersion: dateVersion);

  /// Retrieve the database with [id].
  ///
  /// _See more at https://developers.notion.com/reference/get-database_
  Future<NotionResponse> fetch(String id) async {
    http.Response res =
        await http.get(Uri.https(host, '/$v/$path/$id'), headers: {
      'Authorization': 'Bearer $token',
      'Notion-Version': dateVersion,
    });

    return NotionResponse.fromResponse(res);
  }

  /// Retrieve all databases.
  ///
  /// A [startCursor] can be defined to specify the page where to start.
  /// Also a [pageSize] can be defined to limit the result. The max value is 100.
  ///
  /// _See more at https://developers.notion.com/reference/get-databases_
  Future<NotionResponse> fetchAll({String? startCursor, int? pageSize}) async {
    Map<String, dynamic> query = {};
    if (startCursor != null) {
      query['start_cursor'] = startCursor;
    }
    if (pageSize != null && pageSize >= 0 && pageSize <= 100) {
      query['page_size'] = pageSize.toString();
    }

    http.Response res =
        await http.get(Uri.https(host, '/$v/$path', query), headers: {
      'Authorization': 'Bearer $token',
      'Notion-Version': dateVersion,
    });

    return NotionResponse.fromResponse(res);
  }

  /// Create a database.
  ///
  /// _See more at https://developers.notion.com/reference/create-a-database_
  Future<NotionResponse> create(Database database) async {
    http.Response res = await http.post(
      Uri.https(host, '/$v/$path'),
      body: jsonEncode(database.toJson()),
      headers: {
        'Authorization': 'Bearer $token',
        'Notion-Version': dateVersion,
        'Content-Type': 'application/json',
      },
    );

    return NotionResponse.fromResponse(res);
  }

  /// Query a database.
  ///
  /// _See more at https://developers.notion.com/reference/post-database-query
  Future<NotionResponse> query(
      {required String id,
      required List<DatabaseSort> sorts,
      required Map<String, dynamic> filters}) async {
    http.Response res = await http.post(
      Uri.https(host, '/$v/$path/$id/query'),
      body: jsonEncode({
        "sorts": sorts.map((sort) => sort.toJson()).toList(),
        "filter": filters
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Notion-Version': dateVersion,
        'Content-Type': 'application/json',
      },
    );

    return NotionResponse.fromResponse(res);
  }
}


