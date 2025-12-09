// import 'package:flutter/material.dart';
// import 'package:smart_cashier/models/product.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProductDetailScreen extends StatefulWidget {
//   final Product product;

//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   int _quantity = 1;
//   bool _isLoading = false;

//   void _incrementQuantity() {
//     setState(() {
//       _quantity++;
//     });
//   }

//   void _decrementQuantity() {
//     if (_quantity > 1) {
//       setState(() {
//         _quantity--;
//       });
//     }
//   }

//   Future<void> _addToCart() async {
//     print(
//       'Starting add to cart for product: ${widget.product.name}, quantity: $_quantity',
//     );
//     setState(() => _isLoading = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       print('Retrieved token: ${token != null ? 'present' : 'null'}');
//       if (token == null) {
//         print('No auth token found, aborting add to cart');
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('No auth token found')));
//         return;
//       }
//       final url = 'http://127.0.0.1:8000/api/cart/cart/add/';
//       final headers = {
//         'Authorization': 'Token $token',
//         'Content-Type': 'application/json',
//       };
//       final body = jsonEncode({
//         'product_id': widget.product.id,
//         'qty': _quantity,
//       });
//       print('Sending POST request to $url with body: $body');
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );
//       print('Response status: ${response.statusCode}, body: ${response.body}');
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         print('Successfully added to cart');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Added to cart successfully')),
//         );
//       } else {
//         print('Failed to add to cart with status: ${response.statusCode}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to add to cart: ${response.statusCode}'),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error adding to cart: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product.name),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.red, Colors.orange],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hero Image
//             Hero(
//               tag: 'product_image_${widget.product.id}',
//               child: Container(
//                 height: 300,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                   child: Image.network(
//                     widget.product.imageUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       color: Colors.grey.shade300,
//                       child: const Icon(Icons.image_not_supported, size: 100),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Product Info Card
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.product.name,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           const Icon(Icons.category, color: Colors.grey),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Kategori: ${widget.product.category == "makanan" ? "Makanan" : "Minuman"}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           const Icon(Icons.attach_money, color: Colors.red),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Harga: Rp ${widget.product.price.toStringAsFixed(0)}',
//                             style: const TextStyle(
//                               fontSize: 22,
//                               color: Colors.red,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Deskripsi produk yang lezat dan berkualitas tinggi, siap memanjakan lidah Anda dengan cita rasa terbaik.',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.black54,
//                           height: 1.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Quantity Selector Card
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Tambahkan ke Keranjang',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             decoration: BoxDecoration(
//                               color: Colors.red.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             child: IconButton(
//                               onPressed: _decrementQuantity,
//                               icon: const Icon(Icons.remove, color: Colors.red),
//                               iconSize: 30,
//                             ),
//                           ),
//                           const SizedBox(width: 20),
//                           AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 300),
//                             transitionBuilder: (child, animation) =>
//                                 ScaleTransition(scale: animation, child: child),
//                             child: Text(
//                               '$_quantity',
//                               key: ValueKey<int>(_quantity),
//                               style: const TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 20),
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             decoration: BoxDecoration(
//                               color: Colors.red.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             child: IconButton(
//                               onPressed: _incrementQuantity,
//                               icon: const Icon(Icons.add, color: Colors.red),
//                               iconSize: 30,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _addToCart,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             shadowColor: Colors.transparent,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: Ink(
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [Colors.red, Colors.orange],
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Container(
//                               alignment: Alignment.center,
//                               child: _isLoading
//                                   ? const CircularProgressIndicator(
//                                       color: Colors.white,
//                                     )
//                                   : const Text(
//                                       'Tambah ke Keranjang',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
