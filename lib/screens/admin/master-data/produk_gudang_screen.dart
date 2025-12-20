import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../models/stok_models.dart';
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
import 'update_produk_gudang_screen.dart';
import 'add_product_gudang_screen.dart';
import 'add_category_screen.dart';
import 'add_user_kasir_screen.dart';

class ProdukGudangScreen extends StatefulWidget {
  const ProdukGudangScreen({super.key});

  @override
  State<ProdukGudangScreen> createState() => _ProdukGudangScreenState();
}

class _ProdukGudangScreenState extends State<ProdukGudangScreen> {
  List<GudangProduct> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int selectedDrawerIndex = 12; // Produk Gudang is active (index 12)
  String userRole = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchProducts();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _fetchProducts() async {
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
        Uri.parse('https://flutter001.pythonanywhere.com/api/gudang/produk/'),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data.map((json) => GudangProduct.fromJson(json)).toList();
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

  Future<void> _deleteProduct(GudangProduct product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Token tidak ditemukan')));
        return;
      }

      final response = await http.delete(
        Uri.parse(
          'https://flutter001.pythonanywhere.com/api/gudang/produk/${product.id}/',
        ),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil dihapus')),
        );
        _fetchProducts(); // Refresh the list
      } else {
        String errorMessage = 'Error: ${response.statusCode}';
        try {
          final data = json.decode(response.body);
          errorMessage = data['message'] ?? errorMessage;
        } catch (e) {
          // If response body is empty or not JSON, use default error message
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
          } else if (index == 13) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCategoryScreen(),
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
                "Produk Gudang",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Navigate to add product screen
              Navigator.pushNamed(context, '/add_product_gudang');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Nama Produk')),
                  DataColumn(label: Text('Stok')),
                  DataColumn(label: Text('Satuan')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: _products.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  GudangProduct product = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(product.name)),
                      DataCell(Text(product.stockGudang.toString())),
                      DataCell(Text(product.satuan)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProdukGudangScreen(
                                          product: product,
                                        ),
                                  ),
                                );
                                if (result == true) {
                                  _fetchProducts(); // Refresh the list
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduct(product),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductGudangScreen(),
            ),
          );
          if (result == true) {
            _fetchProducts(); // Refresh the list
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
