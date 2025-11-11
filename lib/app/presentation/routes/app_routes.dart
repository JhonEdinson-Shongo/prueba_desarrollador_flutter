import 'package:flutter/material.dart';

import '../pages/add_address/views/add_address_view.dart';
import '../pages/dashboard/views/dashboard_view.dart';
import '../pages/register/views/register_view.dart';
import '../pages/splash/views/splash_view.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext)> get getAppRoutes {
  return {
    Routes.register: (_) => const RegisterView(),
    Routes.dashboard: (_) => const DashboardView(),
    Routes.addDirection: (_) => const AddAddressView(),
    Routes.splash: (_) => const SplashView(),
  };
}
