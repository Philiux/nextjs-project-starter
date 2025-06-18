import 'package:flutter/material.dart';

enum UserRole { buyer, seller, admin }

class UserProvider with ChangeNotifier {
  UserRole _role = UserRole.buyer;

  UserRole get role => _role;

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }
}
