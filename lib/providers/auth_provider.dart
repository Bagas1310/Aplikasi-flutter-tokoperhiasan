import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database_helper.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('current_user');
    if (userData != null) {
      try {
        final cached =
            UserModel.fromJson(jsonDecode(userData) as Map<String, dynamic>);
        
        // Refresh with latest data from SQLite database
        final dbUser = await DatabaseHelper.instance.getUserById(cached.id);
        if (dbUser != null) {
          _currentUser = dbUser;
        } else {
          _currentUser = cached;
        }
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
    String? phone,
    String? address,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Check if email already registered in SQLite
    final cleanEmail = email.toLowerCase().trim();
    final existingUser =
        await DatabaseHelper.instance.getUserByEmail(cleanEmail);

    if (existingUser != null) {
      _isLoading = false;
      notifyListeners();
      return 'Email sudah terdaftar. Silakan login.';
    }

    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: cleanEmail,
      phone: phone?.trim() ?? '',
      address: address?.trim() ?? '',
      bio: 'Pencinta gelang aesthetic 🌸 | Member since 2026',
      memberSince: DateTime.now(),
    );

    // Save into SQLite Database
    await DatabaseHelper.instance.insertUser(newUser, password);

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

    final cleanEmail = email.toLowerCase().trim();

    // Check user in SQLite Database
    final userMap = await DatabaseHelper.instance.getUserByEmail(cleanEmail);

    if (userMap != null) {
      if (userMap[DatabaseHelper.colPassword] != password) {
        _isLoading = false;
        notifyListeners();
        return 'Password salah. Coba lagi ya!';
      }
      _currentUser = UserModel.fromMap(userMap);
    } else {
      // Demo login: automatically register into SQLite and log in
      final demoUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        fullName: _extractName(email),
        email: cleanEmail,
        phone: '0812-3456-7890',
        address: 'Jl. Gelang Indah No. 7, Bandung',
        bio: 'Pencinta gelang aesthetic 🌸 | Member since 2026',
        memberSince: DateTime.now(),
      );
      await DatabaseHelper.instance.insertUser(demoUser, password);
      _currentUser = demoUser;
    }

    // Persist session to SharedPreferences
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

      // Persist to SQLite Database
      await DatabaseHelper.instance
          .updateProfilePicture(_currentUser!.id, picturePath);

      // Persist session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'current_user', jsonEncode(_currentUser!.toJson()));

      notifyListeners();
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    _currentUser = updatedUser;
    await DatabaseHelper.instance.updateUserProfile(updatedUser);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'current_user', jsonEncode(_currentUser!.toJson()));

    notifyListeners();
  }

  String _extractName(String email) {
    final name = email.split('@').first;
    if (name.isEmpty) return 'Bestie';
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
