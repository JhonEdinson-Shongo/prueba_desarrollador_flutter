import 'address.dart';

class User {
  final String frstName;
  final String lastName;
  final String birthDate;
  final List<Address> addresses;

  User({
    required this.frstName,
    required this.lastName,
    required this.birthDate,
    required this.addresses,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
    frstName: map['frstName'] ?? '',
    lastName: map['lastName'] ?? '',
    birthDate: map['birthDate'],
    addresses: (map['addresses'] as List<dynamic>? ?? [])
        .map((e) => Address.fromMap(e))
        .toList(),
  );

  Map<String, dynamic> toMap() => {
    'frstName': frstName,
    'lastName': lastName,
    'birthDate': birthDate,
    'addresses': addresses.map((a) => (a).toMap()).toList(),
  };
}
