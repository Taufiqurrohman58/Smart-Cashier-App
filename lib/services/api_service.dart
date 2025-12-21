import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/laporan_pengeluaran.dart';
import '../models/laporan_harian.dart';

class ApiService {
  static const String baseUrl = 'https://flutter001.pythonanywhere.com';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<LaporanPengeluaran> fetchPengeluaranReport(DateTime? date) async {
    final token = await _getAuthToken();

    if (token == null) {
      print('Error: Token tidak ditemukan');
      throw Exception('Token tidak ditemukan');
    }

    final effectiveDate = date ?? DateTime.now();
    String url =
        '$baseUrl/api/laporan/harian/?date=${formatDate(effectiveDate)}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic>? pengeluaranData = data['pengeluaran'];

        if (pengeluaranData == null) {
          print('Error: Data pengeluaran tidak ditemukan');
          throw Exception('Data pengeluaran tidak ditemukan');
        }

        return LaporanPengeluaran.fromJson(pengeluaranData);
      } else {
        print(
          'Error: Gagal memuat data pengeluaran (${response.statusCode}) - ${response.body}',
        );
        throw Exception(
          'Gagal memuat data pengeluaran (${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching pengeluaran report: $e');
      rethrow;
    }
  }

  Future<LaporanHarianResponse> fetchLaporanHarian(DateTime? date) async {
    final token = await _getAuthToken();

    if (token == null) {
      print('Error: Token tidak ditemukan');
      throw Exception('Token tidak ditemukan');
    }

    final effectiveDate = date ?? DateTime.now();
    String url =
        '$baseUrl/api/laporan/harian/?date=${formatDate(effectiveDate)}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return LaporanHarianResponse.fromJson(data);
      } else {
        print(
          'Error: Gagal memuat laporan harian (${response.statusCode}) - ${response.body}',
        );
        throw Exception('Gagal memuat laporan harian (${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching laporan harian: $e');
      rethrow;
    }
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
