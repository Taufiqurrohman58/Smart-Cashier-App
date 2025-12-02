import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_cashier/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        setState(() {
          _error = 'No token found';
          _isLoading = false;
        });
        return;
      }
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/products/'),
        headers: {'Authorization': 'Token $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _products = data.map((json) => Product.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load products: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  List<Product> _filterProducts(String category) {
    if (category == 'semua') return _products;
    if (category == 'terlaris')
      return _products.where((e) => e.isRecommended).toList();
    return _products.where((e) => e.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    const List<String> _tabs = ['SEMUA', 'TERLARIS', 'MAKANAN', 'MINUMAN'];
    int currentIndex = _tabController.index;

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F9),
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text(
          "Beranda",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.shopping_cart_checkout),
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: _showMenu),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      bool isSelected = index == currentIndex;
                      return GestureDetector(
                        onTap: () => _tabController.animateTo(index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.red
                                : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ProductList(products: _filterProducts("semua")),
                      ProductList(products: _filterProducts("terlaris")),
                      ProductList(products: _filterProducts("makanan")),
                      ProductList(products: _filterProducts("minuman")),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Keluar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token');
                Navigator.pop(ctx);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products;
  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/product_detail', arguments: product),
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.category == "makanan" ? "Makanan" : "Minuman",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8D8D8D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${product.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF4E4E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.more_vert, size: 20, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
