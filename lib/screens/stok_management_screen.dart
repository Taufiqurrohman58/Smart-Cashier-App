import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/stok_models.dart';
import 'admin_screen.dart';
import 'admin&kasir/history_screen.dart';
import 'lihat_laporan_screen.dart';
import 'ai_insight_screen.dart';
import 'master_data_screen.dart';
import '../widgets/admin_drawer.dart';

class StokManagementScreen extends StatefulWidget {
  const StokManagementScreen({super.key});

  @override
  State<StokManagementScreen> createState() => _StokManagementScreenState();
}

class _StokManagementScreenState extends State<StokManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int selectedDrawerIndex = 4; // Kelola Stok is active

  // Transfer Stok Form
  final TextEditingController _productGudangIdController =
      TextEditingController();
  final TextEditingController _transferQuantityController =
      TextEditingController();

  // Gudang Stok Form
  final TextEditingController _gudangProductIdController =
      TextEditingController();
  final TextEditingController _gudangQuantityController =
      TextEditingController();

  bool _isTransferLoading = false;
  bool _isGudangLoading = false;

  String _transferError = '';
  String _transferSuccess = '';
  String _gudangError = '';
  String _gudangSuccess = '';

  String userName = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _productGudangIdController.dispose();
    _transferQuantityController.dispose();
    _gudangProductIdController.dispose();
    _gudangQuantityController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _transferStok() async {
    if (_productGudangIdController.text.isEmpty ||
        _transferQuantityController.text.isEmpty) {
      setState(() {
        _transferError = 'Product ID dan quantity harus diisi';
      });
      return;
    }

    final productId = int.tryParse(_productGudangIdController.text);
    final quantity = int.tryParse(_transferQuantityController.text);

    if (productId == null || quantity == null || quantity <= 0) {
      setState(() {
        _transferError = 'Product ID dan quantity harus berupa angka positif';
      });
      return;
    }

    setState(() {
      _isTransferLoading = true;
      _transferError = '';
      _transferSuccess = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          _transferError = 'Token tidak ditemukan';
          _isTransferLoading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/kantin/stok/transfer/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({
          "product_gudang_id": productId,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final transferResponse = TransferStokResponse.fromJson(data);
        setState(() {
          _transferSuccess = transferResponse.message;
          _productGudangIdController.clear();
          _transferQuantityController.clear();
        });
      } else {
        setState(() {
          _transferError = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _transferError = 'Error: $e';
      });
    } finally {
      setState(() {
        _isTransferLoading = false;
      });
    }
  }

  Future<void> _tambahStokGudang() async {
    if (_gudangProductIdController.text.isEmpty ||
        _gudangQuantityController.text.isEmpty) {
      setState(() {
        _gudangError = 'Product ID dan quantity harus diisi';
      });
      return;
    }

    final productId = int.tryParse(_gudangProductIdController.text);
    final quantity = int.tryParse(_gudangQuantityController.text);

    if (productId == null || quantity == null || quantity <= 0) {
      setState(() {
        _gudangError = 'Product ID dan quantity harus berupa angka positif';
      });
      return;
    }

    setState(() {
      _isGudangLoading = true;
      _gudangError = '';
      _gudangSuccess = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          _gudangError = 'Token tidak ditemukan';
          _isGudangLoading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/gudang/stok/masuk/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({"product_id": productId, "quantity": quantity}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final gudangResponse = GudangStokResponse.fromJson(data);
        setState(() {
          _gudangSuccess = gudangResponse.message;
          _gudangProductIdController.clear();
          _gudangQuantityController.clear();
        });
      } else {
        setState(() {
          _gudangError = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _gudangError = 'Error: $e';
      });
    } finally {
      setState(() {
        _isGudangLoading = false;
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
              MaterialPageRoute(builder: (context) => const AiInsightScreen()),
            );
          } else if (index == 4) {
            // Already on stok management
          } else if (index == 5) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MasterDataScreen()),
            );
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
              const Text("Kelola Stok", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Transfer ke Kantin"),
            Tab(text: "Tambah Stok Gudang"),
          ],
          indicatorColor: Colors.teal,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTransferTab(), _buildGudangTab()],
      ),
    );
  }

  Widget _buildTransferTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Transfer Stok ke Kantin",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Transfer stok dari gudang ke kantin",
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
                  controller: _productGudangIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Product Gudang ID",
                    hintText: "Masukkan ID produk di gudang",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _transferQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    hintText: "Jumlah yang akan ditransfer",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.swap_horiz),
                  ),
                ),
                const SizedBox(height: 24),

                if (_transferError.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _transferError,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                if (_transferSuccess.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      _transferSuccess,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isTransferLoading ? null : _transferStok,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isTransferLoading
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
    );
  }

  Widget _buildGudangTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tambah Stok Gudang",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Menambah stok produk di gudang",
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
                  controller: _gudangProductIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Product ID",
                    hintText: "Masukkan ID produk",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory_2),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _gudangQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    hintText: "Jumlah yang akan ditambahkan",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.add_circle),
                  ),
                ),
                const SizedBox(height: 24),

                if (_gudangError.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _gudangError,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                if (_gudangSuccess.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      _gudangSuccess,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isGudangLoading ? null : _tambahStokGudang,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isGudangLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Tambah Stok Gudang",
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
    );
  }
}
