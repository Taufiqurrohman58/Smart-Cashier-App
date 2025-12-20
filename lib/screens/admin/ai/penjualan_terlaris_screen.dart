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
import 'rekomendasi_stok_screen.dart';
import 'prediksi_habis_screen.dart';

class PenjualanTerlarisScreen extends StatefulWidget {
  const PenjualanTerlarisScreen({super.key});

  @override
  State<PenjualanTerlarisScreen> createState() =>
      _PenjualanTerlarisScreenState();
}

class _PenjualanTerlarisScreenState extends State<PenjualanTerlarisScreen> {
  int selectedDrawerIndex = 17; // Penjualan Terlaris
  String userName = '';
  String userRole = '';
  List<PenjualanInsight> _penjualanData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPenjualanData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _fetchPenjualanData() async {
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
          'https://flutter001.pythonanywhere.com/api/ai/insight-penjualan/',
        ),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          final List<dynamic> insightData = data['insight'];
          setState(() {
            _penjualanData = insightData
                .map((json) => PenjualanInsight.fromJson(json))
                .toList();
          });
        } else {
          setState(() {
            _errorMessage = 'Gagal memuat data penjualan';
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
                "Penjualan Terlaris",
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
          : _penjualanData.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada data penjualan terlaris',
                style: TextStyle(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Produk')),
                  DataColumn(label: Text('Total Terjual')),
                  DataColumn(label: Text('Total Pendapatan')),
                ],
                rows: _penjualanData.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  PenjualanInsight insight = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(insight.produk)),
                      DataCell(Text(insight.totalTerjual.toString())),
                      DataCell(
                        Text(
                          'Rp ${insight.totalPendapatan.toStringAsFixed(2)}',
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
