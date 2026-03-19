import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  Map<String, dynamic>? _user;

  // Getter
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null;

  // Fungsi Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      
      if (response.statusCode == 200) {
        // Login berhasil
        final data = response.data;
        _token = data['token']?.toString();
        _user = data['user'] as Map<String, dynamic>?;
        
        print('===== USER DATA =====');
        print(_user);
        print('=====================');
        
        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        if (_token != null) {
          await prefs.setString('token', _token!);
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Login gagal
        _errorMessage = response.data['message'] ?? 'Login gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    _user = null;
    notifyListeners();
  }

  // Cek apakah sudah login (dipanggil saat app start)
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    // TODO: validasi token ke server jika perlu
    notifyListeners();
  }
}