import 'package:dio/dio.dart';

class ApiService {
  // GANTI IP INI DENGAN IP LAPTOP KAMU!
  // Cara cek: buka CMD, ketik ipconfig, cari IPv4 Address
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

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      // TAMPILKAN RESPONSE DI TERMINAL
      print('===== RESPONSE LOGIN =====');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');
      print('==========================');

      return response;
    } on DioException catch (e) {
      print('===== DIO ERROR DETAIL =====');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');
      print('Response data: ${e.response?.data}');
      print('============================');

      if (e.response != null) {
        return e.response!;
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
