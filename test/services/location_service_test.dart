import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_desarrollador_flutter/app/data/services/remote/location_service.dart';

void main() {
  test('LocationService.getLocations devuelve mapa con países', () async {
    final service = LocationService();
    final map = await service.getLocations();

    expect(map.isNotEmpty, true);
    expect(map.containsKey('Colombia'), true);
    expect(map['Colombia'], isA<Map<String, dynamic>>());
    expect((map['Colombia'] as Map).containsKey('Antioquia'), true);
  });
}
