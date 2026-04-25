import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConsultationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<dynamic> _consultations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get consultations => _consultations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchConsultations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getConsultations();
      if (response.statusCode == 200) {
        _consultations = response.data;
      } else {
        _errorMessage = 'Gagal memuat data konsultasi';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createConsultation(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.createConsultation(data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchConsultations();
        return true;
      } else {
        _errorMessage = 'Gagal membuat booking';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }
}