import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../../domain/models/Address.dart';
import '../../../../domain/models/user.dart';
import '../../../routes/routes.dart';
import '../../../state/state_notifier.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  String? _frstName, _lastName;
  String? _country, _department, _municipality;
  String? _line1;

  Map<String, dynamic>? _locations;
  List<String> _departments = [];
  List<String> _municipalities = [];

  DateTime? _birthDate;
  bool _loading = false;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final injector = Injector.of(context);
    final locationRepository = injector.locationRepository;
    final locations = await locationRepository.locations;
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
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final injector = Injector.of(context);
    final authenticationRepository = injector.authenticationRepository;
    setState(() => _loading = true);
    User tempUser = User(
      frstName: _frstName!,
      lastName: _lastName!,
      birthDate: '${_birthDate!.day}-${_birthDate!.month}-${_birthDate!.year}',
      addresses: [
        Address(
          id: '1',
          country: _country!,
          department: _department!,
          municipality: _municipality!,
          line1: _line1!,
        ),
      ],
    );
    final response = await authenticationRepository.register(tempUser);
    response.validator(
      (successResponse) {
        final state = Provider.of<StateNotifier>(context, listen: false);
        state.user = tempUser;
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      },
      (errorResponse) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorResponse)));
        setState(() => _loading = false);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _actualizarDepartamentos(String country) {
    setState(() {
      _country = country;
      final map = (_locations![country] as Map<String, dynamic>);
      _departments = map.keys.map((e) => e.toString()).toList();
      _department = null;
      _municipality = null;
      _municipalities = [];
    });
  }

  void _actualizarMunicipios(String department) {
    setState(() {
      _department = department;
      _municipalities = List<String>.from(_locations![_country]![department]);
      _municipality = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario de registro')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: AbsorbPointer(
              absorbing: _loading,
              child: ListView(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) => _frstName = text.trim(),
                    validator: (text) => (text == null || text.trim().isEmpty)
                        ? 'Ingresa un nombre válido'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) => _lastName = text.trim(),
                    validator: (text) => (text == null || text.trim().isEmpty)
                        ? 'Ingresa un apellido válido'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      border: OutlineInputBorder(),
                    ),
                    controller: _dateController,
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Selecciona una fecha"
                        : null,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 20),

                  if (_locations != null)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "País",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _country,
                      items: _locations!.keys
                          .map(
                            (pais) => DropdownMenuItem(
                              value: pais,
                              child: Text(pais),
                            ),
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
                          (dep) =>
                              DropdownMenuItem(value: dep, child: Text(dep)),
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
                          (mun) =>
                              DropdownMenuItem(value: mun, child: Text(mun)),
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
                  const SizedBox(height: 30),
                  MaterialButton(
                    onPressed: _loading ? null : () => _submit(context),
                    color: Colors.amber,
                    height: 50,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text('Registrarse'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
