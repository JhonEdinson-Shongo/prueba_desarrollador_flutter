class Address {
  final String id;
  final String country;
  final String department;
  final String municipality;
  final String line1;

  Address({
    required this.id,
    required this.country,
    required this.department,
    required this.municipality,
    required this.line1,
  });

  factory Address.fromMap(Map<String, dynamic> map) => Address(
    id: map['id'],
    country: map['country'],
    department: map['department'],
    municipality: map['municipality'],
    line1: map['line1'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'country': country,
    'department': department,
    'municipality': municipality,
    'line1': line1,
  };
}
