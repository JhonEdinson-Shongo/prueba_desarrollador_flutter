import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../routes/routes.dart';
import '../../../state/state_notifier.dart';
import '../widgets/card_user.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final injector = Injector.of(context);
    final authenticationRepository = injector.authenticationRepository;
    final tempUser = await authenticationRepository.getUserData();
    if (tempUser != null) {
      final state = Provider.of<StateNotifier>(context, listen: false);
      state.user = tempUser;
    } else if (mounted) {
      _handleBack();
    }
  }

  Future<void> _handleBack() async {
    final injector = Injector.of(context);
    final authenticationRepository = injector.authenticationRepository;
    authenticationRepository.cleanUser();
    Navigator.pushReplacementNamed(context, Routes.register);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<StateNotifier>(context);
    final dataUser = notifier.user;
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard de usuario')),
      body: SafeArea(
        child: Column(
          children: [
            if (dataUser != null) CardUser(dataUser: dataUser),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.addDirection),
                      color: Colors.amber,
                      child: Text('Agregar dirección'),
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        _handleBack();
                      },
                      color: Colors.red,
                      child: Text(
                        'Crear nuevo usuario',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
