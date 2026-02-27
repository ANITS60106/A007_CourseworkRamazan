import 'dart:convert';
import 'package:http/http.dart' as http;

/// Very small API client for the Django backend (prototype).
class ApiClient {
  // If you run Android emulator: http://10.0.2.2:8080
  // If you run on Chrome locally: http://127.0.0.1:8080
  static String baseUrl = 'http://127.0.0.1:8080';

  static String? _token;

  static void setToken(String? token) {
    _token = token;
  }

  static Map<String, String> _withAuth(Map<String, String>? headers) {
    return {
      if (_token != null) 'Authorization': 'Token $_token',
      ...?headers,
    };
  }

  static Future<String> login({
    required String username,
    required String password,
  }) async {
    final data = await post(
      '/api/auth/login/',
      body: {'username': username, 'password': password},
    );

    final token = (data['token'] ?? data['key'])?.toString();
    if (token == null || token.isEmpty) {
      throw ApiException(500, {'error': 'Token not found', 'response': data});
    }

    setToken(token);
    return token;
  }

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
        ..._withAuth(headers),
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
    final res = await http.get(uri, headers: _withAuth(headers));

    final decoded = res.body.isEmpty ? [] : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded is List ? decoded : [];
    }
    throw ApiException(res.statusCode, decoded);
  }

  /// Convenience GET that returns decoded JSON (List or Map).
  /// Keeps the rest of the codebase simpler.
  static Future<dynamic> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.get(uri, headers: _withAuth(headers));

    final decoded = res.body.isEmpty ? null : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }
    throw ApiException(res.statusCode, decoded);
  }

  static Future<Map<String, dynamic>> getMap(
      String path, {
        Map<String, String>? headers,
      }) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.get(uri, headers: _withAuth(headers));

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