import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/either.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  static const _userJsonKey = 'user_json';
  static const _keyUserId = 'user_id';
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences prefs;

  AuthenticationRepositoryImpl(this._secureStorage, this.prefs);

  @override
  Future<User?> getUserData() async {
    try {
      final jsonStr = prefs.getString(_userJsonKey);
      if (jsonStr == null) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      print('= = = = = = > ${map.toString()}');
      return User.fromMap(map);
    } catch (e) {
      print('=======> $e');
      return null;
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    final sessionId = await _secureStorage.read(key: _keyUserId);
    return sessionId != null;
  }

  @override
  Future<Either<String, String>> register(User user) async {
    try {
      final jsonStr = jsonEncode(user.toMap());
      await prefs.setString(_userJsonKey, jsonStr);
      _secureStorage.write(key: _keyUserId, value: 'user_id');
      return Either.success('Usuario guardado');
    } catch (e) {
      return Either.error('No se ha podido guardar el usuario $e');
    }
  }

  @override
  Future<void> cleanUser() async {
    prefs.clear();
    _secureStorage.delete(key: _keyUserId);
  }
}
