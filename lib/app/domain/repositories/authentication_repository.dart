import '../either.dart';
import '../models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isAuthenticated;
  Future<User?> getUserData();
  Future<Either<String, String>> register(User user);
  Future<void> cleanUser();
}
