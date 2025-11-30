import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_cashier/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> products = [
    Product(name: 'Nasi Goreng', price: 15000, imageUrl: 'https://cdn.kibrispdr.org/data/454/gambar-minuman-di-cafe-0.jpg', category: 'makanan', isRecommended: true),
    Product(name: 'Ayam Bakar', price: 20000, imageUrl: 'https://cdn.kibrispdr.org/data/454/gambar-minuman-di-cafe-0.jpg', category: 'makanan', isRecommended: false),
    Product(name: 'Sate Ayam', price: 25000, imageUrl: 'https://cdn.kibrispdr.org/data/454/gambar-minuman-di-cafe-0.jpg', category: 'makanan', isRecommended: true),
    Product(name: 'Es Teh', price: 5000, imageUrl: 'https://cdn.kibrispdr.org/data/454/gambar-minuman-di-cafe-0.jpg', category: 'minuman', isRecommended: false),
    Product(name: 'Jus Jeruk', price: 10000, imageUrl: 'https://cdn.kibrispdr.org/data/454/gambar-minuman-di-cafe-0.jpg', category: 'minuman', isRecommended: true),
    Product(name: 'Kopi Hitam', price: 8000, imageUrl: 'https://cdn.kibrispdr.org/data/454/gambar-minuman-di-cafe-0.jpg', category: 'minuman', isRecommended: false),
    Product(name: 'Mie Goreng', price: 12000, imageUrl: 'https://cdn.kibrispdr.org/data/454/gambar-minuman-di-cafe-0.jpg', category: 'makanan', isRecommended: false),
    Product(name: 'Susu Coklat', price: 7000, imageUrl: 'https://cdn.kibrispdr.org/data/454/gambar-minuman-di-cafe-0.jpg', category: 'minuman', isRecommended: false),
  ];

  List<Product> _filterProducts(String category) {
    if (category == 'semua') return products;
    if (category == 'rekomendasi') return products.where((e) => e.isRecommended).toList();
    return products.where((e) => e.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xffF7F7F9),
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Smart Cashier", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_checkout),
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
            ),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: _showMenu),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Semua"),
              Tab(text: "Rekomendasi"),
              Tab(text: "Makanan"),
              Tab(text: "Minuman"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            ProductList(products: _filterProducts("semua")),
            ProductList(products: _filterProducts("rekomendasi")),
            ProductList(products: _filterProducts("makanan")),
            ProductList(products: _filterProducts("minuman")),
          ],
        ),
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
              title: const Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
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
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(product.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text(
                    product.category == "makanan" ? "Makanan" : "Minuman",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Rp ${product.price.toStringAsFixed(0)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff2ECC71), fontSize: 17),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
