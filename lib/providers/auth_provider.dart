import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  // Simple in-memory "database" backed by SharedPreferences
  final Map<String, Map<String, String>> _registeredUsers = {};

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('current_user');
    if (userData != null) {
      try {
        _currentUser =
            UserModel.fromJson(jsonDecode(userData) as Map<String, dynamic>);
        notifyListeners();
      } catch (_) {
        await prefs.remove('current_user');
      }
    }
  }

  Future<String?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final key = email.toLowerCase().trim();
    if (_registeredUsers.containsKey(key)) {
      _isLoading = false;
      notifyListeners();
      return 'Email sudah terdaftar. Silakan login.';
    }

    _registeredUsers[key] = {
      'fullName': fullName,
      'email': email,
      'password': password,
    };

    _isLoading = false;
    notifyListeners();
    return null; // success
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final key = email.toLowerCase().trim();

    // Check registered users first, then allow demo login
    if (_registeredUsers.containsKey(key)) {
      if (_registeredUsers[key]!['password'] != password) {
        _isLoading = false;
        notifyListeners();
        return 'Password salah. Coba lagi ya!';
      }
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: _registeredUsers[key]!['fullName']!,
        email: email,
        phone: '0812-3456-7890',
        address: 'Jl. Gelang Indah No. 7, Bandung',
        bio: 'Pencinta gelang aesthetic 🌸 | Member since 2026',
        memberSince: DateTime.now(),
      );
    } else {
      // Demo login – allow any email/password
      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: _extractName(email),
        email: email,
        phone: '0812-3456-7890',
        address: 'Jl. Gelang Indah No. 7, Bandung',
        bio: 'Pencinta gelang aesthetic 🌸 | Member since 2026',
        memberSince: DateTime.now(),
      );
    }

    // Persist session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'current_user', jsonEncode(_currentUser!.toJson()));

    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    notifyListeners();
  }

  Future<void> updateProfilePicture(String picturePath) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(profilePicturePath: picturePath);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'current_user', jsonEncode(_currentUser!.toJson()));
      notifyListeners();
    }
  }

  String _extractName(String email) {
    final name = email.split('@').first;
    return name[0].toUpperCase() + name.substring(1);
  }
}

/// InheritedWidget wrapper so descendants can access the provider
class AuthProviderScope extends InheritedNotifier<AuthProvider> {
  final AuthProvider provider;

  const AuthProviderScope({
    super.key,
    required this.provider,
    required super.child,
  }) : super(notifier: provider);

  static AuthProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthProviderScope>()!
        .provider;
  }
}
