// import 'package:flutter/material.dart';
// import 'package:smart_cashier/models/product.dart';

// class CheckoutScreen extends StatefulWidget {
//   final List<Product> items;
//   const CheckoutScreen({super.key, this.items = const []});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final Map<Product, bool> selectedStatus = {};
//   final TextEditingController _paymentController = TextEditingController();
//   double total = 0;
//   double change = 0;

//   @override
//   void initState() {
//     super.initState();
//     for (var item in widget.items) {
//       selectedStatus[item] = true;
//     }
//     _calculateTotal();
//   }

//   void _calculateTotal() {
//     total = widget.items.where((item) => selectedStatus[item] == true).fold(0, (sum, item) => sum + item.price);
//     setState(() {});
//   }

//   void _calculateChange() {
//     double paid = double.tryParse(_paymentController.text) ?? 0;
//     change = paid - total;
//     setState(() {});
//   }

//   void _removeItem(Product p) {
//     setState(() {
//       widget.items.remove(p);
//       selectedStatus.remove(p);
//       _calculateTotal();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Checkout")),

//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.items.length,
//               itemBuilder: (context, i) {
//                 final p = widget.items[i];
//                 return ListTile(
//                   leading: Checkbox(
//                     value: selectedStatus[p],
//                     onChanged: (val) {
//                       setState(() {
//                         selectedStatus[p] = val!;
//                         _calculateTotal();
//                       });
//                     },
//                   ),
//                   title: Text(p.name),
//                   subtitle: Text("Rp ${p.price}"),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.more_vert),
//                     onPressed: () => _removeItem(p),
//                   ),
//                 );
//               },
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text("Total: Rp $total", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: _paymentController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     labelText: "Pembayaran",
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (v) => _calculateChange(),
//                 ),

//                 const SizedBox(height: 12),
//                 Text(
//                   "Kembalian: Rp $change",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: change < 0 ? Colors.red : Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
