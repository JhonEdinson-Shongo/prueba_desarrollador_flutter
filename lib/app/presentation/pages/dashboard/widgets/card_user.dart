import 'package:flutter/material.dart';

import '../../../../domain/models/user.dart';

class CardUser extends StatelessWidget {
  const CardUser({super.key, required this.dataUser});

  final User dataUser;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                TextSpan(text: dataUser.frstName),
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
                TextSpan(text: dataUser.lastName),
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
                TextSpan(text: dataUser.birthDate),
              ],
            ),
          ),
          SizedBox(height: 10),
          ...dataUser.addresses.map((e) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              color: Colors.blueGrey[100],
              margin: EdgeInsets.only(bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.line1),
                  Text('${e.country} - ${e.department} - ${e.municipality}'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
