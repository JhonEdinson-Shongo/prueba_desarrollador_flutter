import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../../domain/models/user.dart';
import '../../../routes/routes.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  User? dataUser;
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
      setState(() {
        dataUser = tempUser;
      });
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
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard de usuario')),
      body: SafeArea(
        child: Column(
          children: [
            Text('Datos del usuario'),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                color: Colors.white,
              ),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Nombre: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: dataUser!.frstName),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Apellido: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: dataUser!.lastName),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cumpleaños: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: dataUser!.birthDate),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ...dataUser!.addresses.map((e) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      color: Colors.blueGrey[100],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.line1),
                          Text(
                            '${e.country} - ${e.department} - ${e.municipality}',
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {},
                      color: Colors.amber,
                      child: Text('Agregar dirección'),
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        _handleBack();
                      },
                      color: Colors.amber,
                      child: Text('Crear nuevo usuario'),
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
