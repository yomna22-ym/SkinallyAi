import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiManager {
  static const String baseUrl = "https://skinally.runasp.net/api/auth";

  static Future<http.Response> postData({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: json.encode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}