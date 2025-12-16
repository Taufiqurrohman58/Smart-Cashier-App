import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddProductGudangScreen extends StatefulWidget {
  const AddProductGudangScreen({super.key});

  @override
  State<AddProductGudangScreen> createState() => _AddProductGudangScreenState();
}

class _AddProductGudangScreenState extends State<AddProductGudangScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _initialStockController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _initialStockController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _initialStockController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Semua field harus diisi';
      });
      return;
    }

    final price = double.tryParse(_priceController.text);
    final stock = int.tryParse(_initialStockController.text);

    if (price == null || price <= 0) {
      setState(() {
        _errorMessage = 'Harga harus berupa angka positif';
      });
      return;
    }

    if (stock == null || stock < 0) {
      setState(() {
        _errorMessage = 'Stok awal harus berupa angka non-negatif';
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
        Uri.parse('http://127.0.0.1:8000/api/gudang/produk/tambah/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({
          "name": _nameController.text,
          "price": price,
          "category": _categoryController.text,
          "initial_stock": stock,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          _successMessage = data['message'] ?? 'Produk berhasil ditambahkan';
          _nameController.clear();
          _priceController.clear();
          _categoryController.clear();
          _initialStockController.clear();
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Tambah Produk Gudang",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tambah Produk Baru",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tambahkan produk baru ke gudang",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
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
                      labelText: "Nama Produk",
                      hintText: "Masukkan nama produk",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Harga (Rp)",
                      hintText: "Masukkan harga produk",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                      hintText: "Masukkan kategori produk",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _initialStockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stok Awal",
                      hintText: "Masukkan jumlah stok awal",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory),
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
                      onPressed: _isLoading ? null : _addProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Tambah Produk",
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