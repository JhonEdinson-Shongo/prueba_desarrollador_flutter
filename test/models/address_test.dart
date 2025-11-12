import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_desarrollador_flutter/app/domain/models/address.dart';

void main() {
  group('Address model', () {
    test('toMap / fromMap redondea correctamente', () {
      final address = Address(
        id: '1',
        country: 'Colombia',
        department: 'Antioquia',
        municipality: 'Medellín',
        line1: 'Cra 1 #2-3',
      );

      final map = address.toMap();
      expect(map, {
        'id': '1',
        'country': 'Colombia',
        'department': 'Antioquia',
        'municipality': 'Medellín',
        'line1': 'Cra 1 #2-3',
      });

      final again = Address.fromMap(map);
      expect(again.id, address.id);
      expect(again.country, address.country);
      expect(again.department, address.department);
      expect(again.municipality, address.municipality);
      expect(again.line1, address.line1);
    });
  });
}
