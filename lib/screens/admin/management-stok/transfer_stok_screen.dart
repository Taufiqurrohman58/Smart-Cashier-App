import 'package:flutter/material.dart';
import '../../../widgets/admin_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin_screen.dart';
import '../../admin/admin_history_screen.dart';
import '../../admin/laporan/laporan_pengeluaran_screen.dart';
import '../../admin/laporan/laporan_harian_screen.dart';
import '../../admin/laporan/laporan_bulanan_screen.dart';
import '../../admin/laporan/laporan_tahunan_screen.dart';
import '../../admin/laporan/export_laporan_screen.dart';
import '../../admin/management-stok/tambah_stok_screen.dart';
import '../../admin/ai/penjualan_terlaris_screen.dart';
import '../../admin/ai/rekomendasi_stok_screen.dart';
import '../../admin/ai/prediksi_habis_screen.dart';
import '../../admin/master-data/add_category_screen.dart';
import '../../admin/master-data/produk_gudang_screen.dart';
import '../../admin/master-data/add_user_kasir_screen.dart';
import '../../../models/warehouse_product.dart';
import '../../../services/api_service.dart';

class TransferStokScreen extends StatefulWidget {
  const TransferStokScreen({super.key});

  @override
  State<TransferStokScreen> createState() => _TransferStokScreenState();
}

class _TransferStokScreenState extends State<TransferStokScreen> {
  int selectedDrawerIndex = 15; // Transfer Stok
  String userName = '';
  String userRole = '';

  final ApiService _apiService = ApiService();
  final TextEditingController _quantityController = TextEditingController();

  List<WarehouseProduct> _products = [];
  WarehouseProduct? _selectedProduct;
  bool _isLoading = false;
  bool _isTransferring = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProducts();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final products = await _apiService.fetchWarehouseProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data produk: $e';
      });
    }
  }

  Future<void> _transferStock() async {
    if (_selectedProduct == null) {
      setState(() {
        _errorMessage = 'Pilih produk terlebih dahulu';
      });
      return;
    }

    final quantityText = _quantityController.text.trim();
    if (quantityText.isEmpty) {
      setState(() {
        _errorMessage = 'Masukkan jumlah stok';
      });
      return;
    }

    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      setState(() {
        _errorMessage = 'Jumlah stok harus berupa angka positif';
      });
      return;
    }

    setState(() {
      _isTransferring = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      await _apiService.transferStockToKantin(_selectedProduct!.id, quantity);

      setState(() {
        _successMessage = 'Stok berhasil ditransfer ke kantin!';
        _quantityController.clear();
        _selectedProduct = null;
        _isTransferring = false;
      });
    } catch (e) {
      setState(() {
        _isTransferring = false;
        _errorMessage = 'Gagal mentransfer stok: $e';
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
                "Transfer Stok",
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _loadProducts,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Transfer Stok Gudang ke Kantin",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Pindahkan stok produk dari gudang ke kantin",
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
                  // Product Selection Dropdown
                  DropdownButtonFormField<WarehouseProduct>(
                    value: _selectedProduct,
                    decoration: const InputDecoration(
                      labelText: "Pilih Produk",
                      hintText: "Pilih produk dari gudang",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.warehouse),
                    ),
                    items: _products.map((product) {
                      return DropdownMenuItem<WarehouseProduct>(
                        value: product,
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (product) {
                      setState(() {
                        _selectedProduct = product;
                        _errorMessage = '';
                        _successMessage = '';
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Quantity Input
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Jumlah Stok",
                      hintText: "Masukkan jumlah yang akan ditransfer",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.swap_horiz),
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
                      onPressed: _isTransferring ? null : _transferStock,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isTransferring
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Transfer Stok",
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
