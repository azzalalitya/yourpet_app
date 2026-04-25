import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Helper: ambil token dari SharedPreferences & pasang ke header
  Future<void> _setAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // ==================== AUTH ====================
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      print('===== RESPONSE LOGIN =====');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      print('==========================');
      return response;
    } on DioException catch (e) {
      print('===== DIO ERROR DETAIL =====');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('============================');
      if (e.response != null) return e.response!;
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Response> logout() async {
    await _setAuthHeader();
    try {
      final response = await _dio.post('/logout');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Network error: ${e.message}');
    }
  }

  // ==================== PRODUCTS (Master Data) ====================
  Future<Response> getProducts() async {
    await _setAuthHeader();
    try {
      final response = await _dio.get('/products');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Gagal ambil produk: ${e.message}');
    }
  }

  Future<Response> createProduct(Map<String, dynamic> data) async {
    await _setAuthHeader();
    try {
      final response = await _dio.post('/products', data: data);
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Gagal tambah produk: ${e.message}');
    }
  }

  Future<Response> updateProduct(int id, Map<String, dynamic> data) async {
    await _setAuthHeader();
    try {
      final response = await _dio.put('/products/$id', data: data);
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Gagal update produk: ${e.message}');
    }
  }

    // ==================== DOCTORS ====================
  Future<Response> getDoctors() async {
    await _setAuthHeader();
    try {
      final response = await _dio.get('/doctors');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Gagal ambil data dokter: ${e.message}');
    }
  }

  // ==================== CONSULTATIONS ====================
  Future<Response> getConsultations() async {
    await _setAuthHeader();
    try {
      final response = await _dio.get('/consultations');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Gagal ambil konsultasi: ${e.message}');
    }
  }

  Future<Response> createConsultation(Map<String, dynamic> data) async {
    await _setAuthHeader();
    try {
      final response = await _dio.post('/consultations', data: data);
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Gagal buat konsultasi: ${e.message}');
    }
  }
  
  Future<Response> deleteProduct(int id) async {
    await _setAuthHeader();
    try {
      final response = await _dio.delete('/products/$id');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Gagal hapus produk: ${e.message}');
    }
  }
}