import '../Models/register_request.dart';
import '../Models/register_response.dart';
import '../Models/login_request.dart';
import '../Models/login_response.dart';

abstract class AuthRepository {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<LoginResponse> login(LoginRequest request);
}