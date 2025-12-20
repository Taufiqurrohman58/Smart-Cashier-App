import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../widgets/admin_drawer.dart';
import '../../admin_screen.dart';
import '../admin_history_screen.dart';
import '../laporan/laporan_pengeluaran_screen.dart';
import '../laporan/laporan_harian_screen.dart';
import '../laporan/laporan_bulanan_screen.dart';
import '../laporan/laporan_tahunan_screen.dart';
import '../laporan/export_laporan_screen.dart';
import '../management-stok/transfer_stok_screen.dart';
import '../management-stok/tambah_stok_screen.dart';
import '../ai/penjualan_terlaris_screen.dart';
import '../ai/rekomendasi_stok_screen.dart';
import '../ai/prediksi_habis_screen.dart';
import 'produk_gudang_screen.dart';
import 'add_user_kasir_screen.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';
  int selectedDrawerIndex = 13; // Add Category is active (index 13)
  String userRole = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _addCategory() async {
    if (_nameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Nama kategori harus diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
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

      final response = await http.post(
        Uri.parse('https://flutter001.pythonanywhere.com/api/categories/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({"name": _nameController.text}),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          _successMessage = 'Kategori "${data['name']}" berhasil ditambahkan';
          _nameController.clear();
        });
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
                "Tambah Kategori",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tambah Kategori Baru",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tambahkan kategori produk baru",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Kategori",
                      hintText: "Masukkan nama kategori",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  if (_successMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        _successMessage,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _addCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Tambah Kategori",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
