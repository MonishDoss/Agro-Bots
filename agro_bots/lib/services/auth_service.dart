import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> signIn(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock user data
      _currentUser = UserModel(
        id: '1',
        fullName: 'Sharma',
        email: email,
        profileImage: null,
      );

      _isLoggedIn = true;

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);

      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> signUp(String fullName, String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName,
        email: email,
      );

      _isLoggedIn = true;

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      await prefs.setString('userFullName', fullName);

      notifyListeners();
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  Future<void> updateProfile(String fullName, String email) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(fullName: fullName, email: email);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userFullName', fullName);
      await prefs.setString('userEmail', email);

      notifyListeners();
    }
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (_isLoggedIn) {
      final email = prefs.getString('userEmail') ?? '';
      final fullName = prefs.getString('userFullName') ?? 'User';

      _currentUser = UserModel(id: '1', fullName: fullName, email: email);
    }

    notifyListeners();
  }
}
