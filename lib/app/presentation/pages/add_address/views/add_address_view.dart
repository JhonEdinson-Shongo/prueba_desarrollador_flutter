import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../../domain/models/address.dart';
import '../../../../domain/models/user.dart';
import '../../../routes/routes.dart';
import '../../../state/state_notifier.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final _formKey = GlobalKey<FormState>();

  // Campos del formulario
  String? _country;
  String? _department;
  String? _municipality;
  String? _line1;
  User? _user;

  // Datos de ubicaciones
  Map<String, dynamic> _locations = {};
  List<String> _countries = const [];
  List<String> _departments = const [];
  List<String> _municipalities = const [];

  bool _loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    super.initState();
  }

  Future<void> _init() async {
    try {
      final injector = Injector.of(context);
      final locationRepository = injector.locationRepository;
      final authenticationRepository = injector.authenticationRepository;
      final locations = await locationRepository.locations;
      final user = await authenticationRepository.getUserData();
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
      if (locations != null) {
        setState(() {
          _locations = locations;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ha ocurrido un error al obtener las locaciones'),
          ),
        );
      }
    } catch (e) {
      _locations = {};
      _countries = const [];
    }
  }

  void _actualizarDepartamentos(String country) {
    setState(() {
      _country = country;
      final map = (_locations[country] as Map<String, dynamic>);
      _departments = map.keys.map((e) => e.toString()).toList();
      _department = null;
      _municipality = null;
      _municipalities = [];
    });
  }

  void _actualizarMunicipios(String department) {
    setState(() {
      _department = department;
      _municipalities = List<String>.from(_locations[_country]![department]);
      _municipality = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final address = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        country: _country!.trim(),
        department: _department!.trim(),
        municipality: _municipality!.trim(),
        line1: _line1!.trim(),
      );
      final injector = Injector.of(context);
      final updatedUser = await injector.authenticationRepository.addAddress(
        address,
      );

      if (!mounted) return;
      if (updatedUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dirección guardada correctamente')),
        );
        final state = Provider.of<StateNotifier>(context, listen: false);
        state.user = updatedUser;
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No fue posible guardar la dirección')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Agregar dirección')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_user != null ? _user!.frstName : 'Cargando...'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "País",
                  border: OutlineInputBorder(),
                ),
                initialValue: _country,
                items: _locations.keys
                    .map(
                      (pais) =>
                          DropdownMenuItem(value: pais, child: Text(pais)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) _actualizarDepartamentos(value);
                },
                validator: (value) => (value == null || value.isEmpty)
                    ? "Selecciona un país"
                    : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Departamento",
                  border: OutlineInputBorder(),
                ),
                initialValue: _department,
                items: _departments
                    .map(
                      (dep) => DropdownMenuItem(value: dep, child: Text(dep)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) _actualizarMunicipios(value);
                },
                validator: (value) => (value == null || value.isEmpty)
                    ? "Selecciona un departamento"
                    : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Municipio",
                  border: OutlineInputBorder(),
                ),
                initialValue: _municipality,
                items: _municipalities
                    .map(
                      (mun) => DropdownMenuItem(value: mun, child: Text(mun)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _municipality = value),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Selecciona un municipio"
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) => _line1 = text.trim(),
                validator: (text) => (text == null || text.trim().isEmpty)
                    ? 'Ingresa una dirección'
                    : null,
              ),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  _submit();
                },
                color: Colors.amber,
                child: Text('Agregar dirección'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
