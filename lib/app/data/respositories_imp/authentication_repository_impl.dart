import '../../domain/either.dart';
import '../../domain/models/User.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<User?> getUserData() async {
    return null;
  }

  @override
  Future<bool> get isAuthenticated => Future.value(false);

  @override
  Future<Either<String, String>> register(User user) async {
    return Either.success('Por ahorra inicio sessión!!!');
  }
}
