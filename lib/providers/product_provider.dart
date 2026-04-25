import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // ==================== PRODUCTS ====================
  List<dynamic> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getter
  List<dynamic> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Ambil data produk dari API
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getProducts();
      if (response.statusCode == 200) {
        _products = response.data;
      } else {
        _errorMessage = 'Gagal memuat produk dari server';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tambah produk baru
  Future<bool> addProduct(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.createProduct(data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchProducts(); // Refresh list setelah tambah
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Update produk
  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.updateProduct(id, data);
      if (response.statusCode == 200) {
        await fetchProducts(); // Refresh list
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Hapus produk
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _apiService.deleteProduct(id);
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchProducts(); // Refresh list
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
    return false;
  }

  // ==================== DOCTORS (Konsultasi) ====================
  List<dynamic> _doctors = [];
  List<dynamic> get doctors => _doctors;

  Future<void> fetchDoctors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getDoctors();
      if (response.statusCode == 200) {
        _doctors = response.data;
      } else {
        _errorMessage = 'Gagal memuat data dokter';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}