import 'package:flutter/material.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Añadir dirección')),
      body: Center(child: Text('Add direction')),
    );
  }
}
