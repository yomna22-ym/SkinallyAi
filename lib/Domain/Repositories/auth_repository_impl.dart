import '../../Data/DataSources/auth_remote_data_source.dart';
import '../../Domain/Models/register_request.dart';
import '../../Domain/Models/register_response.dart';
import '../../Domain/Models/login_request.dart';
import '../../Domain/Models/login_response.dart';
import '../../Domain/Repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    return await remoteDataSource.register(request);
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return await remoteDataSource.login(request);
  }
}