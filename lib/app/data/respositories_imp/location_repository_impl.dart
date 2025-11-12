import '../../domain/repositories/location_repository.dart';
import '../services/remote/location_service.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl(this.locationService);

  @override
  // TODO: implement locations
  Future<Map<String, dynamic>?> get locations async {
    final locations = locationService.getLocations();
    return locations;
  }
}
