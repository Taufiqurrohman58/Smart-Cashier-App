import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/stok_models.dart';

class UpdateProdukGudangScreen extends StatefulWidget {
  final GudangProduct product;

  const UpdateProdukGudangScreen({super.key, required this.product});

  @override
  State<UpdateProdukGudangScreen> createState() =>
      _UpdateProdukGudangScreenState();
}

class _UpdateProdukGudangScreenState extends State<UpdateProdukGudangScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _categoryController.text = widget.product.category;
    _priceController.text = widget.product.price;
    _stockController.text = widget.product.stockGudang.toString();
    _satuanController.text = widget.product.satuan;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _satuanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProduct() async {
    if (_nameController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _satuanController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Semua field harus diisi';
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

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(
          'https://flutter001.pythonanywhere.com/api/gudang/produk/${widget.product.id}/',
        ),
      );

      request.headers['Authorization'] = 'Token $token';

      request.fields['name'] = _nameController.text;
      request.fields['category'] = _categoryController.text;
      request.fields['price'] = _priceController.text;
      request.fields['stock_gudang'] = _stockController.text;
      request.fields['satuan'] = _satuanController.text;

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);

      if (response.statusCode == 200) {
        setState(() {
          _successMessage = 'Produk berhasil diperbarui';
        });
        // Optionally navigate back or refresh
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context, true); // Return true to indicate update
        });
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'Error: ${response.statusCode}';
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

  Future<void> _deleteProduct() async {
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

      final response = await http.delete(
        Uri.parse(
          'https://flutter001.pythonanywhere.com/api/gudang/produk/${widget.product.id}/',
        ),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 204) {
        setState(() {
          _successMessage = 'Produk berhasil dihapus';
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context, true); // Return true to indicate deletion
        });
      } else {
        String errorMessage = 'Error: ${response.statusCode}';
        try {
          final data = json.decode(response.body);
          errorMessage = data['message'] ?? errorMessage;
        } catch (e) {
          // If response body is empty or not JSON, use default error message
        }
        setState(() {
          _errorMessage = errorMessage;
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
          "Update Produk Gudang",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _isLoading ? null : _deleteProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update Produk Gudang",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Perbarui informasi produk gudang",
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
                      labelText: "Nama Produk",
                      hintText: "Masukkan nama produk",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: "Kategori",
                      hintText: "Masukkan kategori (e.g., Minuman)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Harga",
                      hintText: "Masukkan harga",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stok Gudang",
                      hintText: "Masukkan stok gudang",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.storage),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _satuanController,
                    decoration: const InputDecoration(
                      labelText: "Satuan",
                      hintText: "Masukkan satuan (pcs, kg, dll)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.scale),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image Picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gambar Produk",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _imageFile != null
                              ? Stack(
                                  children: [
                                    Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Text(
                                          'Baru',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : widget.product.image != null &&
                                    widget.product.image!.isNotEmpty
                              ? Stack(
                                  children: [
                                    Image.network(
                                      'https://flutter001.pythonanywhere.com${widget.product.image}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_a_photo,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Pilih Gambar Baru',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Text(
                                          'Saat Ini',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Pilih Gambar',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
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
                      onPressed: _isLoading ? null : _updateProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Update Produk",
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
