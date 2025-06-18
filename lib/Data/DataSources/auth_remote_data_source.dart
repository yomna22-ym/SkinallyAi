import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Core/Network/api_manager.dart';
import '../../Domain/Models/register_request.dart';
import '../../Domain/Models/register_response.dart';
import '../../Domain/Models/login_request.dart';
import '../../Domain/Models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<LoginResponse> login(LoginRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await ApiManager.postData(
        endpoint: '/register',
        body: request.toJson(),
      );

      print("Raw API response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return RegisterResponse.fromJson(jsonResponse);
      } else {
        final errorResponse = json.decode(response.body);
        return RegisterResponse(
          success: false,
          message: errorResponse['message'] ?? 'Registration failed',
        );
      }

    } catch (e) {
      return RegisterResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await ApiManager.postData(
        endpoint: '/login',
        body: request.toJson(),
      );

      print("Login API raw response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return LoginResponse.fromJson(jsonResponse);
      } else {
        final errorResponse = json.decode(response.body);
        return LoginResponse(
          success: false,
          message: errorResponse['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

}
