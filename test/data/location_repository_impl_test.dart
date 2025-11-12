import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_desarrollador_flutter/app/data/respositories_imp/location_repository_impl.dart';
import 'package:prueba_desarrollador_flutter/app/data/services/remote/location_service.dart';

void main() {
  test('LocationRepositoryImpl.locations retorna lo del service', () async {
    final repo = LocationRepositoryImpl(LocationService());
    final map = await repo.locations;

    expect(map, isNotNull);
    expect(map!.containsKey('México'), true);
  });
}
