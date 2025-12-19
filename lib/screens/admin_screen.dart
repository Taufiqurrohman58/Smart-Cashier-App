import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/category_menu.dart';
import 'admin/admin_history_screen.dart';
import 'package:smart_cashier/screens/admin/master-data/add_category_screen.dart';
import 'package:smart_cashier/screens/admin/master-data/add_user_kasir_screen.dart';
import 'package:smart_cashier/screens/admin/master-data/produk_gudang_screen.dart';
import 'admin/laporan/laporan_pengeluaran_screen.dart';
import 'admin/laporan/laporan_harian_screen.dart';
import 'admin/laporan/laporan_bulanan_screen.dart';
import 'admin/laporan/laporan_tahunan_screen.dart';
import 'admin/laporan/export_laporan_screen.dart';
import 'admin/management-stok/transfer_stok_screen.dart';
import 'admin/management-stok/tambah_stok_screen.dart';
import 'admin/ai/penjualan_terlaris_screen.dart';
import 'admin/ai/rekomendasi_stok_screen.dart';
import 'admin/ai/prediksi_habis_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int totalItem = 0;
  int subtotal = 0;

  int selectedCategoryIndex = 0;
  int selectedDrawerIndex = 0;

  bool isSearchMode = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final List<String> categories = ["Semua", "Makanan", "Minuman", "Snack"];

  List<Product> products = [];
  bool isLoading = true;
  String errorMessage = '';
  String userRole = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    print('AdminScreen: initState called');
    _fetchProducts();
    _loadUserData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _fetchProducts() async {
    print('AdminScreen: _fetchProducts called');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print(
        'AdminScreen: Token retrieved: ${token != null ? 'present' : 'null'}',
      );

      if (token == null) {
        setState(() {
          errorMessage = 'Token tidak ditemukan';
          isLoading = false;
        });
        print('AdminScreen: No token found, setting error');
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/kantin/produk/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', // 🔥 WAJIB ganti ke "Token"
        },
      );

      print('AdminScreen: API response status: ${response.statusCode}');
      print('AdminScreen: API body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((json) => Product.fromJson(json)).toList();
          isLoading = false;
        });
        print(
          'AdminScreen: Products loaded successfully, count: ${products.length}',
        );
      } else {
        setState(() {
          errorMessage = 'Gagal memuat produk (${response.statusCode})';
          isLoading = false;
        });
        print(
          'AdminScreen: Failed to load products, status: ${response.statusCode}',
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('AdminScreen: Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),

      // ================= DRAWER =================
      drawer: AdminDrawer(
        userName: userName,
        userRole: userRole,
        selectedIndex: selectedDrawerIndex,
        onIndexChanged: (index) {
          setState(() {
            selectedDrawerIndex = index;
          });
          Navigator.pop(context);
          if (index == 1) {
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
              MaterialPageRoute(builder: (context) => const LaporanBulananScreen()),
            );
          } else if (index == 9) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LaporanTahunanScreen()),
            );
          } else if (index == 11) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExportLaporanScreen()),
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
          } else if (index == 11) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ExportLaporanScreen(),
              ),
            );
          } else if (index == 12) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProdukGudangScreen()),
            );
          } else if (index == 14) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AddUserKasirScreen()),
            );
          } else if (index == 13) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AddCategoryScreen()),
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
              MaterialPageRoute(builder: (context) => const RekomendasiStokScreen()),
            );
          } else if (index == 17) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PrediksiHabisScreen(),
              ),
            );
          }
        },
      ),

      appBar: isSearchMode
          ? AppBar(
              backgroundColor: const Color(0xFF1D1D1F),
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isSearchMode = false;
                    searchQuery = '';
                    searchController.clear();
                  });
                },
              ),
              title: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Cari produk...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            )
          : AppBar(
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
                      "Admin",
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
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearchMode = true;
                    });
                  },
                ),

                // ================= TITIK TIGA (LOGOUT) =================
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'logout', child: Text("Keluar")),
                  ],
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutDialog();
                    }
                  },
                ),
              ],
            ),

      body: SafeArea(
        child: Column(
          children: [
            CategoryMenu(
              selectedIndex: selectedCategoryIndex,
              onIndexChanged: (index) {
                setState(() {
                  selectedCategoryIndex = index;
                });
              },
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : ListView(
                      padding: const EdgeInsets.all(12),
                      children: () {
                        List<Product> filteredProducts = products
                            .where(
                              (p) => p.name.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ),
                            )
                            .toList();
                        return filteredProducts
                            .map((product) => _menuItem(product))
                            .toList();
                      }(),
                    ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  // ================= MENU ITEM =================
  Widget _menuItem(Product product) {
    return GestureDetector(
      onTap: () {
        _showQtyDialog(title: product.name, price: product.price);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.image.isNotEmpty
                  ? Image.network(
                      product.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : _noImage(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rp${product.price}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= QTY DIALOG =================
  void _showQtyDialog({required String title, required String price}) {
    int qty = 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Rp${double.parse(price).toInt()}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _qtyButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (qty > 1) {
                              setStateDialog(() => qty--);
                            }
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text(
                            qty.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _qtyButton(
                          icon: Icons.add,
                          onTap: () {
                            setStateDialog(() => qty++);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Kembali"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                totalItem += qty;
                                subtotal += double.parse(price).toInt() * qty;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Simpan"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _noImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  // ================= BOTTOM BAR =================
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$totalItem Items",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "Subtotal Rp$subtotal",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/order',
                arguments: {
                  'title': 'Ayam Goreng Sambal Merah',
                  'price': 20000,
                  'qty': totalItem,
                },
              );
            },
            child: const Row(
              children: [
                Text("Lihat Pesanan", style: TextStyle(color: Colors.white)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGOUT DIALOG =================
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Keluar"),
        content: const Text("Yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }
}
