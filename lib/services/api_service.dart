import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/laporan_pengeluaran.dart';
import '../models/laporan_harian.dart';
import '../models/laporan_bulanan.dart';
import '../models/laporan_tahunan.dart';
import '../models/warehouse_product.dart';

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

  Future<LaporanBulananResponse> fetchLaporanBulanan(
    int month,
    int year,
  ) async {
    final token = await _getAuthToken();

    if (token == null) {
      print('Error: Token tidak ditemukan');
      throw Exception('Token tidak ditemukan');
    }

    String url = '$baseUrl/api/laporan/bulanan/?month=$month&year=$year';

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
        return LaporanBulananResponse.fromJson(data);
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Parameter month dan year wajib');
      } else {
        print(
          'Error: Gagal memuat laporan bulanan (${response.statusCode}) - ${response.body}',
        );
        throw Exception(
          'Gagal memuat laporan bulanan (${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching laporan bulanan: $e');
      rethrow;
    }
  }

  Future<LaporanTahunanResponse> fetchLaporanTahunan(int year) async {
    final token = await _getAuthToken();

    if (token == null) {
      print('Error: Token tidak ditemukan');
      throw Exception('Token tidak ditemukan');
    }

    String url = '$baseUrl/api/laporan/tahunan/?year=$year';

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
        return LaporanTahunanResponse.fromJson(data);
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Parameter year wajib');
      } else {
        print(
          'Error: Gagal memuat laporan tahunan (${response.statusCode}) - ${response.body}',
        );
        throw Exception(
          'Gagal memuat laporan tahunan (${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching laporan tahunan: $e');
      rethrow;
    }
  }

  Future<String> downloadExcelReport(DateTime date) async {
    final token = await _getAuthToken();

    if (token == null) {
      print('Error: Token tidak ditemukan');
      throw Exception('Token tidak ditemukan');
    }

    // For modern Android, use app-specific storage to avoid permission issues
    // No storage permission needed for app-specific directories

    final fileName = 'laporan_${formatDate(date)}.xlsx';

    // Starting download process
    print('Starting download: $fileName');

    String url =
        '$baseUrl/api/kantin/rekap/export-excel/?date=${formatDate(date)}';

    try {
      // Download started, 25% progress
      print('Download progress: 25%');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Token $token'},
      );

      // Download in progress, 50% complete
      print('Download progress: 50%');

      if (response.statusCode == 200) {
        // File processing, 75% complete
        print('Download progress: 75%');

        // Get the downloads directory - use app-specific storage first
        Directory? directory;

        if (Platform.isAndroid) {
          // For Android, try app-specific directory first (no permission needed)
          try {
            directory = await getApplicationDocumentsDirectory();
          } catch (e) {
            // Fallback to external storage if available
            try {
              directory = await getExternalStorageDirectory();
              if (directory != null) {
                final downloadsPath = '${directory.path}/Download';
                directory = Directory(downloadsPath);
              }
            } catch (e2) {
              // Final fallback to app documents directory
              directory = await getApplicationDocumentsDirectory();
            }
          }
        } else if (Platform.isIOS) {
          // For iOS, use documents directory
          directory = await getApplicationDocumentsDirectory();
        } else {
          // For other platforms, use application documents directory
          directory = await getApplicationDocumentsDirectory();
        }

        if (directory == null) {
          throw Exception('Tidak dapat mengakses direktori penyimpanan');
        }

        // Create directory if it doesn't exist
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final filePath = '${directory.path}/$fileName';

        // Write the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Download completed successfully
        print('Download completed: $fileName');

        return filePath;
      } else {
        print(
          'Error: Gagal mengunduh file Excel (${response.statusCode}) - ${response.body}',
        );
        throw Exception('Gagal mengunduh file Excel (${response.statusCode})');
      }
    } catch (e) {
      // Download failed
      print('Download failed: $fileName');
      print('Error downloading Excel report: $e');
      rethrow;
    }
  }

  // Fetch warehouse products
  Future<List<WarehouseProduct>> fetchWarehouseProducts() async {
    final token = await _getAuthToken();

    if (token == null) {
      print('Error: Token tidak ditemukan');
      throw Exception('Token tidak ditemukan');
    }

    String url = '$baseUrl/api/gudang/produk/';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WarehouseProduct.fromJson(json)).toList();
      } else {
        print(
          'Error: Gagal memuat data produk gudang (${response.statusCode}) - ${response.body}',
        );
        throw Exception(
          'Gagal memuat data produk gudang (${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching warehouse products: $e');
      rethrow;
    }
  }

  // Add stock to warehouse
  Future<void> addStockToWarehouse(int productId, int quantity) async {
    final token = await _getAuthToken();

    if (token == null) {
      print('Error: Token tidak ditemukan');
      throw Exception('Token tidak ditemukan');
    }

    String url = '$baseUrl/api/gudang/stok/masuk/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({'product_id': productId, 'quantity': quantity}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Stok berhasil ditambahkan');
      } else {
        print(
          'Error: Gagal menambahkan stok (${response.statusCode}) - ${response.body}',
        );
        throw Exception('Gagal menambahkan stok (${response.statusCode})');
      }
    } catch (e) {
      print('Error adding stock to warehouse: $e');
      rethrow;
    }
  }

  // Transfer stock from warehouse to kantin
  Future<void> transferStockToKantin(int productGudangId, int quantity) async {
    final token = await _getAuthToken();

    if (token == null) {
      print('Error: Token tidak ditemukan');
      throw Exception('Token tidak ditemukan');
    }

    String url = '$baseUrl/api/kantin/stok/transfer/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({
          'product_gudang_id': productGudangId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['message'] ?? 'Stok berhasil ditransfer ke kantin');
      } else {
        print(
          'Error: Gagal mentransfer stok (${response.statusCode}) - ${response.body}',
        );
        throw Exception('Gagal mentransfer stok (${response.statusCode})');
      }
    } catch (e) {
      print('Error transferring stock to kantin: $e');
      rethrow;
    }
  }
}
