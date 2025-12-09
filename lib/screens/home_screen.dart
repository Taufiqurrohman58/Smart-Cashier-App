import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import 'history_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  void initState() {
    super.initState();
    print('HomeScreen: initState called');
    _fetchProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

Future<void> _fetchProducts() async {
  print('HomeScreen: _fetchProducts called');
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('HomeScreen: Token retrieved: ${token != null ? 'present' : 'null'}');

    if (token == null) {
      setState(() {
        errorMessage = 'Token tidak ditemukan';
        isLoading = false;
      });
      print('HomeScreen: No token found, setting error');
      return;
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/products/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',   // 🔥 WAJIB ganti ke “Token”
      },
    );

    print('HomeScreen: API response status: ${response.statusCode}');
    print('HomeScreen: API body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data.map((json) => Product.fromJson(json)).toList();
        isLoading = false;
      });
      print('HomeScreen: Products loaded successfully, count: ${products.length}');
    } else {
      setState(() {
        errorMessage = 'Gagal memuat produk (${response.statusCode})';
        isLoading = false;
      });
      print('HomeScreen: Failed to load products, status: ${response.statusCode}');
    }
  } catch (e) {
    setState(() {
      errorMessage = 'Error: $e';
      isLoading = false;
    });
    print('HomeScreen: Error fetching products: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),

      // ================= DRAWER =================
      drawer: _buildDrawer(),

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
                      "Beranda",
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
            _categoryMenu(),
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

  // ================= DRAWER UI =================
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.teal,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, size: 39),
                ),
                const SizedBox(width: 6),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Taufiq",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text("Kasir", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          _drawerItem(icon: Icons.home, title: "Beranda", index: 0),
          _drawerItem(icon: Icons.history, title: "History", index: 1),
          _drawerItem(icon: Icons.bar_chart, title: "Laporan", index: 2),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    bool active = selectedDrawerIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedDrawerIndex = index;
        });
        Navigator.pop(context);
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReportScreen()),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? Colors.teal.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: active ? Border.all(color: Colors.teal, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? Colors.teal : Colors.grey),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: active ? Colors.teal : Colors.black,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CATEGORY =================
  Widget _categoryMenu() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryIndex = index;
              });
            },
            child: _chip(categories[index], selectedCategoryIndex == index),
          );
        },
      ),
    );
  }

  Widget _chip(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Chip(
        backgroundColor: active
            ? const Color(0xFF1D1D1F)
            : Colors.grey.shade200,
        label: Text(
          text,
          style: TextStyle(color: active ? Colors.white : Colors.black),
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
              child: Image.network(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
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
            onPressed: () {
              Navigator.pop(context);
              // arahkan ke login screen jika ada
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }
}
