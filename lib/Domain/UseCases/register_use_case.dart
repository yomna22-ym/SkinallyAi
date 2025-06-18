import '../Models/register_request.dart';
import '../Models/register_response.dart';
import '../Repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<RegisterResponse> execute(RegisterRequest request) async {
    return await repository.register(request);
  }
}