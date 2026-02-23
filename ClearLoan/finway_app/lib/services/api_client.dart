import 'dart:convert';
import 'package:http/http.dart' as http;

/// Very small API client for the Django backend (prototype).
class ApiClient {
  // If you run Android emulator: http://10.0.2.2:8000
  // If you run on Chrome locally: http://127.0.0.1:8000
  static String baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
      body: body == null ? null : jsonEncode(body),
    );
    final decoded = res.body.isEmpty ? {} : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    }
    throw ApiException(res.statusCode, decoded);
  }

  static Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.get(uri, headers: headers);
    final decoded = res.body.isEmpty ? [] : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is List ? decoded : [];
    }
    throw ApiException(res.statusCode, decoded);
  }

  static Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.get(uri, headers: headers);
    final decoded = res.body.isEmpty ? {} : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    }
    throw ApiException(res.statusCode, decoded);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final dynamic body;

  ApiException(this.statusCode, this.body);

  @override
  String toString() => 'ApiException($statusCode): $body';
}
