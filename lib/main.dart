import 'package:flutter/material.dart';

import 'app/data/respositories_imp/authentication_repository_impl.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/my_app.dart';

void main() {
  runApp(
    Injector(
      authenticationRepository: AuthenticationRepositoryImpl(),
      child: const MyApp(),
    ),
  );
}

class Injector extends InheritedWidget {
  const Injector({
    super.key,
    required super.child,
    required this.authenticationRepository,
  });

  final AuthenticationRepository authenticationRepository;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    if (injector == null) throw Exception('No se encontro ningun injector');
    return injector;
  }
}
