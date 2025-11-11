import 'Address.dart';

class User {
  final String frstName;
  final String lastName;
  final DateTime birthDate;
  final List<Address> addresses;

  User({
    required this.frstName,
    required this.lastName,
    required this.birthDate,
    required this.addresses,
  });
}
