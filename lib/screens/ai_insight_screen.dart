import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/insight_models.dart';
import 'admin_screen.dart';
import 'admin&kasir/admin_history_screen.dart';
import 'laporan_pengeluaran_screen.dart';
import 'stok_management_screen.dart';
import 'master_data_screen.dart';
import 'report_menu_screen.dart';
import '../widgets/admin_drawer.dart';

class AiInsightScreen extends StatefulWidget {
  const AiInsightScreen({super.key});

  @override
  State<AiInsightScreen> createState() => _AiInsightScreenState();
}

class _AiInsightScreenState extends State<AiInsightScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int selectedDrawerIndex = 6; // AI Insight is active

  // Data states
  List<PenjualanInsight> penjualanData = [];
  List<StokRekomendasi> stokRekomendasiData = [];
  List<PrediksiHabis> prediksiHabisData = [];

  bool isLoadingPenjualan = true;
  bool isLoadingStok = true;
  bool isLoadingPrediksi = true;

  String errorPenjualan = '';
  String errorStok = '';
  String errorPrediksi = '';

  String userName = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
    _fetchAllInsights();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _fetchAllInsights() async {
    await Future.wait([
      _fetchPenjualanInsight(),
      _fetchStokRekomendasi(),
      _fetchPrediksiHabis(),
    ]);
  }

  Future<void> _fetchPenjualanInsight() async {
    setState(() {
      isLoadingPenjualan = true;
      errorPenjualan = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          errorPenjualan = 'Token tidak ditemukan';
          isLoadingPenjualan = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/insight/penjualan/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            penjualanData = (data['data'] as List<dynamic>)
                .map((json) => PenjualanInsight.fromJson(json))
                .toList();
            isLoadingPenjualan = false;
          });
        } else {
          setState(() {
            errorPenjualan = 'Gagal memuat data';
            isLoadingPenjualan = false;
          });
        }
      } else {
        setState(() {
          errorPenjualan = 'Error: ${response.statusCode}';
          isLoadingPenjualan = false;
        });
      }
    } catch (e) {
      setState(() {
        errorPenjualan = 'Error: $e';
        isLoadingPenjualan = false;
      });
    }
  }

  Future<void> _fetchStokRekomendasi() async {
    setState(() {
      isLoadingStok = true;
      errorStok = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          errorStok = 'Token tidak ditemukan';
          isLoadingStok = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/insight/rekomendasi-stok/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            stokRekomendasiData = (data['data'] as List<dynamic>)
                .map((json) => StokRekomendasi.fromJson(json))
                .toList();
            isLoadingStok = false;
          });
        } else {
          setState(() {
            errorStok = 'Gagal memuat data';
            isLoadingStok = false;
          });
        }
      } else {
        setState(() {
          errorStok = 'Error: ${response.statusCode}';
          isLoadingStok = false;
        });
      }
    } catch (e) {
      setState(() {
        errorStok = 'Error: $e';
        isLoadingStok = false;
      });
    }
  }

  Future<void> _fetchPrediksiHabis() async {
    setState(() {
      isLoadingPrediksi = true;
      errorPrediksi = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          errorPrediksi = 'Token tidak ditemukan';
          isLoadingPrediksi = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/insight/prediksi-habis/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            prediksiHabisData = (data['data'] as List<dynamic>)
                .map((json) => PrediksiHabis.fromJson(json))
                .toList();
            isLoadingPrediksi = false;
          });
        } else {
          setState(() {
            errorPrediksi = 'Gagal memuat data';
            isLoadingPrediksi = false;
          });
        }
      } else {
        setState(() {
          errorPrediksi = 'Error: ${response.statusCode}';
          isLoadingPrediksi = false;
        });
      }
    } catch (e) {
      setState(() {
        errorPrediksi = 'Error: $e';
        isLoadingPrediksi = false;
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
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LaporanScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StokManagementScreen(),
              ),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MasterDataScreen()),
            );
          } else if (index == 5) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReportMenuScreen()),
            );
          } else if (index == 6) {
            // Already on AI Insight
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1F),
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (context) => Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              const Text("AI Insight", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Penjualan"),
            Tab(text: "Rekomendasi Stok"),
            Tab(text: "Prediksi Habis"),
          ],
          indicatorColor: Colors.teal,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildPenjualanTab(), _buildStokTab(), _buildPrediksiTab()],
      ),
    );
  }

  Widget _buildPenjualanTab() {
    if (isLoadingPenjualan) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorPenjualan.isNotEmpty) {
      return Center(child: Text(errorPenjualan));
    }

    if (penjualanData.isEmpty) {
      return const Center(child: Text('Tidak ada data penjualan'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: penjualanData.length,
      itemBuilder: (context, index) {
        final item = penjualanData[index];
        return _insightCard(
          title: item.produk,
          subtitle: 'Total Terjual: ${item.totalTerjual}',
          value:
              'Rp${item.totalPendapatan.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          icon: Icons.trending_up,
          color: Colors.green,
        );
      },
    );
  }

  Widget _buildStokTab() {
    if (isLoadingStok) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorStok.isNotEmpty) {
      return Center(child: Text(errorStok));
    }

    if (stokRekomendasiData.isEmpty) {
      return const Center(child: Text('Tidak ada rekomendasi stok'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: stokRekomendasiData.length,
      itemBuilder: (context, index) {
        final item = stokRekomendasiData[index];
        return _insightCard(
          title: item.produk,
          subtitle:
              'Stok Sekarang: ${item.stokSekarang} → Saran: ${item.saranStok}',
          value: item.alasan,
          icon: Icons.inventory,
          color: Colors.blue,
        );
      },
    );
  }

  Widget _buildPrediksiTab() {
    if (isLoadingPrediksi) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorPrediksi.isNotEmpty) {
      return Center(child: Text(errorPrediksi));
    }

    if (prediksiHabisData.isEmpty) {
      return const Center(child: Text('Tidak ada prediksi habis'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: prediksiHabisData.length,
      itemBuilder: (context, index) {
        final item = prediksiHabisData[index];
        return _insightCard(
          title: item.produk,
          subtitle:
              'Stok: ${item.stokSekarang} | Estimasi: ${item.estimasiHabisHari} hari',
          value: item.status,
          icon: Icons.warning,
          color: item.status == 'Segera Habis' ? Colors.red : Colors.orange,
        );
      },
    );
  }

  Widget _insightCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
