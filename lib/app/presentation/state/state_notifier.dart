import 'package:flutter/material.dart';

import '../../domain/models/user.dart';

class StateNotifier extends ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _locations;

  User? get user => _user;
  Map<String, dynamic>? get locations => _locations;

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  set locations(Map<String, dynamic> locations) {
    _locations = locations;
    notifyListeners();
  }
}
