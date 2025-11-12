import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_desarrollador_flutter/app/domain/models/address.dart';
import 'package:prueba_desarrollador_flutter/app/domain/models/user.dart';

void main() {
  group('User model', () {
    test('toMap / fromMap redondea correctamente', () {
      final user = User(
        frstName: 'Jhon',
        lastName: 'Doe',
        birthDate: '01-01-1998',
        addresses: [
          Address(
            id: '1',
            country: 'Colombia',
            department: 'Santander',
            municipality: 'Bucaramanga',
            line1: 'Cra 33 apt 2015',
          ),
        ],
      );

      final map = user.toMap();
      expect(map['frstName'], 'Jhon');
      expect(map['lastName'], 'Doe');
      expect(map['birthDate'], '01-01-1998');
      expect(map['addresses'], isA<List<dynamic>>());

      final again = User.fromMap(map);
      expect(again.frstName, user.frstName);
      expect(again.lastName, user.lastName);
      expect(again.birthDate, user.birthDate);
      expect(again.addresses.length, 1);
      expect(again.addresses.first.country, 'Colombia');
    });

    test('fromMap maneja nulos/ausentes con defaults', () {
      final again = User.fromMap({'birthDate': '2000-01-01'});

      expect(again.frstName, '');
      expect(again.lastName, '');
      expect(again.addresses, isEmpty);
    });
  });
}
