import 'package:flutter/material.dart';

import '../../domain/models/user.dart';

class StateNotifier extends ChangeNotifier {
  User? _user;

  User? get user {
    return _user;
  }

  set user(User user) {
    _user = user;
    notifyListeners();
  }
}
