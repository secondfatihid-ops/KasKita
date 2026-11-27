import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Cek apakah user sedang login saat aplikasi pertama kali dibuka
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr != null) {
      _currentUser = UserModel.fromJson(jsonDecode(userStr));
      notifyListeners();
    }
  }

  // Proses Login
  Future<bool> login(String email, String password, Function(String) onError) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);

    _isLoading = false;
    notifyListeners();

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');
      if (userStr != null) {
        _currentUser = UserModel.fromJson(jsonDecode(userStr));
      }
      return true;
    } else {
      onError(result['message']);
      return false;
    }
  }

  // Proses Register
  Future<bool> register(String name, String email, String password, String role, Function(String, bool) onFinished) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(name, email, password, role);

    _isLoading = false;
    notifyListeners();

    onFinished(result['message'], result['success']);
    return result['success'];
  }

  // Proses Logout
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }
}