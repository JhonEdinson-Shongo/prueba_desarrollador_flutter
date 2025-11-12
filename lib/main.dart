import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/data/respositories_imp/authentication_repository_impl.dart';
import 'app/data/respositories_imp/location_repository_impl.dart';
import 'app/data/services/remote/location_service.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/location_repository.dart';
import 'app/my_app.dart';
import 'app/presentation/state/state_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => StateNotifier())],
      child: Injector(
        authenticationRepository: AuthenticationRepositoryImpl(
          FlutterSecureStorage(),
          prefs,
        ),
        locationRepository: LocationRepositoryImpl(LocationService()),
        child: const MyApp(),
      ),
    ),
  );
}

class Injector extends InheritedWidget {
  const Injector({
    super.key,
    required super.child,
    required this.authenticationRepository,
    required this.locationRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final LocationRepository locationRepository;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    if (injector == null) throw Exception('No se encontro ningun injector');
    return injector;
  }
}
