import '../either.dart';
import '../models/address.dart';
import '../models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isAuthenticated;
  Future<User?> getUserData();
  Future<Either<String, String>> register(User user);
  Future<void> cleanUser();
  Future<User?> addAddress(Address address);
}
