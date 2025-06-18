import '../Models/login_request.dart';
import '../Models/login_response.dart';
import '../Repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<LoginResponse> execute(LoginRequest request) async {
    return await repository.login(request);
  }
}