import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  // Mock login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: 'user_1',
        email: email,
        displayName: email.split('@')[0],
        avatarUrl: 'https://i.pravatar.cc/150?u=user_1',
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Mock register
  Future<bool> register(String email, String password, String displayName) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: 'user_new',
        email: email,
        displayName: displayName,
        avatarUrl: 'https://i.pravatar.cc/150?u=user_new',
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
