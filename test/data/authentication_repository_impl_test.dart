import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_desarrollador_flutter/app/data/respositories_imp/authentication_repository_impl.dart';
import 'package:prueba_desarrollador_flutter/app/domain/models/address.dart';
import 'package:prueba_desarrollador_flutter/app/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const AndroidOptions());
    registerFallbackValue(const IOSOptions());
    registerFallbackValue(const LinuxOptions());
    registerFallbackValue(const WindowsOptions());
    registerFallbackValue(const WebOptions());
    registerFallbackValue(const MacOsOptions());
  });

  group('AuthenticationRepositoryImpl', () {
    late MockSecureStorage secure;
    late SharedPreferences prefs;
    late AuthenticationRepositoryImpl repo;

    setUp(() async {
      secure = MockSecureStorage();
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = AuthenticationRepositoryImpl(secure, prefs);
    });

    test(
      'register guarda user en prefs y user_id en secure storage (success)',
      () async {
        final user = User(
          frstName: 'Jhon',
          lastName: 'Doe',
          birthDate: '1995-10-01',
          addresses: [
            Address(
              id: 'a1',
              country: 'Colombia',
              department: 'Antioquia',
              municipality: 'Medellín',
              line1: 'Cra 1 #2-3',
            ),
          ],
        );

        when(
          () => secure.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        final res = await repo.register(user);
        expect(
          res.validator((success) => success, (error) => error),
          'Usuario guardado',
        );

        final jsonStr = prefs.getString('user_json');
        expect(jsonStr, isNotNull);

        final decoded = jsonDecode(jsonStr!);
        expect(decoded['frstName'], 'Jhon');

        verify(() => secure.write(key: 'user_id', value: 'user_id')).called(1);
      },
    );

    test('isAuthenticated true cuando hay user_id en secure storage', () async {
      when(() => secure.read(key: any(named: 'key'))).thenAnswer(
        (inv) async => inv.namedArguments[const Symbol('key')] == 'user_id'
            ? 'user_id'
            : null,
      );

      final isAuth = await repo.isAuthenticated;
      expect(isAuth, true);
    });

    test('isAuthenticated false cuando NO hay user_id', () async {
      when(
        () => secure.read(key: any(named: 'key')),
      ).thenAnswer((_) async => null);

      final isAuth = await repo.isAuthenticated;
      expect(isAuth, false);
    });

    test('getUserData devuelve null si no hay user_json', () async {
      final user = await repo.getUserData();
      expect(user, isNull);
    });

    test('getUserData devuelve User si existe user_json válido', () async {
      final map = {
        'frstName': 'Ana',
        'lastName': 'Pérez',
        'birthDate': '2000-01-01',
        'addresses': [],
      };
      await prefs.setString('user_json', jsonEncode(map));

      final user = await repo.getUserData();
      expect(user, isNotNull);
      expect(user!.frstName, 'Ana');
    });

    test('cleanUser limpia prefs y borra user_id', () async {
      await prefs.setString('user_json', '{}');

      when(
        () => secure.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      await repo.cleanUser();

      expect(prefs.getKeys(), isEmpty);
      verify(() => secure.delete(key: 'user_id')).called(1);
    });
  });
}
