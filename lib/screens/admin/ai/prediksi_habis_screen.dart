import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/admin_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/insight_models.dart';
import '../../admin_screen.dart';
import '../admin_history_screen.dart';
import '../laporan/laporan_pengeluaran_screen.dart';
import '../laporan/laporan_harian_screen.dart';
import '../laporan/laporan_bulanan_screen.dart';
import '../laporan/laporan_tahunan_screen.dart';
import '../laporan/export_laporan_screen.dart';
import '../management-stok/transfer_stok_screen.dart';
import '../management-stok/tambah_stok_screen.dart';
import '../master-data/produk_gudang_screen.dart';
import '../master-data/add_category_screen.dart';
import '../master-data/add_user_kasir_screen.dart';
import 'penjualan_terlaris_screen.dart';
import 'rekomendasi_stok_screen.dart';

class PrediksiHabisScreen extends StatefulWidget {
  const PrediksiHabisScreen({super.key});

  @override
  State<PrediksiHabisScreen> createState() => _PrediksiHabisScreenState();
}

class _PrediksiHabisScreenState extends State<PrediksiHabisScreen> {
  int selectedDrawerIndex = 19; // Prediksi Habis
  String userName = '';
  String userRole = '';
  List<PrediksiHabis> _prediksiData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPrediksiData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _fetchPrediksiData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          _errorMessage = 'Token tidak ditemukan';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://flutter001.pythonanywhere.com/api/ai/prediksi-habis/',
        ),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          final List<dynamic> prediksiData = data['prediksi'];
          setState(() {
            _prediksiData = prediksiData
                .map((json) => PrediksiHabis.fromJson(json))
                .toList();
          });
        } else {
          setState(() {
            _errorMessage = 'Gagal memuat data prediksi habis';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      drawer: AdminDrawer(
        userName: userName,
        userRole: userRole,
        selectedIndex: selectedDrawerIndex,
        onIndexChanged: (index) {
          setState(() {
            selectedDrawerIndex = index;
          });
          Navigator.pop(context);
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
          } else if (index == 10) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LaporanScreen()),
            );
          } else if (index == 7) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LaporanHarianScreen(),
              ),
            );
          } else if (index == 8) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LaporanBulananScreen(),
              ),
            );
          } else if (index == 9) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LaporanTahunanScreen(),
              ),
            );
          } else if (index == 11) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ExportLaporanScreen(),
              ),
            );
          } else if (index == 15) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TransferStokScreen(),
              ),
            );
          } else if (index == 16) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TambahStokScreen()),
            );
          } else if (index == 12) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProdukGudangScreen(),
              ),
            );
          } else if (index == 14) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUserKasirScreen(),
              ),
            );
          } else if (index == 13) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCategoryScreen(),
              ),
            );
          } else if (index == 17) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PenjualanTerlarisScreen(),
              ),
            );
          } else if (index == 18) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const RekomendasiStokScreen(),
              ),
            );
          } else if (index == 19) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PrediksiHabisScreen(),
              ),
            );
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1F),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Builder(
          builder: (context) => Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              const Text(
                "Prediksi Habis",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : _prediksiData.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada data prediksi habis',
                style: TextStyle(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Produk')),
                  DataColumn(label: Text('Stok Sekarang')),
                  DataColumn(label: Text('Estimasi Habis (Hari)')),
                  DataColumn(label: Text('Status')),
                ],
                rows: _prediksiData.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  PrediksiHabis prediksi = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(prediksi.produk)),
                      DataCell(Text(prediksi.stokSekarang.toString())),
                      DataCell(Text(prediksi.estimasiHabisHari.toString())),
                      DataCell(
                        Text(
                          prediksi.status,
                          style: TextStyle(
                            color: prediksi.status == 'Segera Habis'
                                ? Colors.red
                                : prediksi.status == 'Tidak Ada Penjualan'
                                ? Colors.orange
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
