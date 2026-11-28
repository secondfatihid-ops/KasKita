import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  static final ApiClient instance = ApiClient();
  static final Uri baseUri = resolveBaseUri(
    override: const String.fromEnvironment('API_BASE_URL'),
    isWeb: kIsWeb,
    platform: defaultTargetPlatform,
    browserUri: Uri.base,
  );

  final http.Client _client;

  static Uri resolveBaseUri({
    String? override,
    bool? isWeb,
    TargetPlatform? platform,
    Uri? browserUri,
  }) {
    final configuredUrl = override?.trim() ?? '';
    late final Uri uri;

    if (configuredUrl.isNotEmpty) {
      uri = Uri.parse(configuredUrl);
    } else if (isWeb ?? kIsWeb) {
      final location = browserUri ?? Uri.base;
      uri = Uri(
        scheme: location.scheme == 'https' ? 'https' : 'http',
        host: location.host.isEmpty ? 'localhost' : location.host,
        port: 5000,
        path: '/api',
      );
    } else if ((platform ?? defaultTargetPlatform) == TargetPlatform.android) {
      uri = Uri.parse('http://10.0.2.2:5000/api');
    } else {
      uri = Uri.parse('http://localhost:5000/api');
    }

    final path = uri.path.replaceFirst(RegExp(r'/+$'), '');
    final apiPath = path.endsWith('/api') ? path : '$path/api';
    return uri.replace(path: '$apiPath/');
  }

  Uri _endpoint(String path) {
    return baseUri.resolve(path.replaceFirst(RegExp(r'^/+'), ''));
  }

  Future<Map<String, String>> _headers({
    bool jsonContentType = false,
    bool authenticated = true,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (jsonContentType) {
      headers['Content-Type'] = 'application/json';
    }
    if (authenticated) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<http.Response> get(String path) async {
    return _client.get(_endpoint(path), headers: await _headers());
  }

  Future<http.Response> postJson(
    String path,
    Map<String, dynamic> body, {
    bool authenticated = true,
  }) async {
    return _client.post(
      _endpoint(path),
      headers: await _headers(
        jsonContentType: true,
        authenticated: authenticated,
      ),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> putJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _client.put(
      _endpoint(path),
      headers: await _headers(jsonContentType: true),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) async {
    return _client.delete(_endpoint(path), headers: await _headers());
  }

  Future<http.Response> sendMultipart({
    required String method,
    required String path,
    required Map<String, String> fields,
    List<http.MultipartFile> files = const [],
  }) async {
    final request = http.MultipartRequest(method, _endpoint(path))
      ..headers.addAll(await _headers())
      ..fields.addAll(fields)
      ..files.addAll(files);
    return http.Response.fromStream(await _client.send(request));
  }
}
