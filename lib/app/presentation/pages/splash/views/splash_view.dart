import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final injector = Injector.of(context);
    await Future.delayed(const Duration(seconds: 2));
    final authenticationRepository = injector.authenticationRepository;
    final isAuthenticated = await authenticationRepository.isAuthenticated;
    if (isAuthenticated) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.dashboard);
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
