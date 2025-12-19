import 'package:flutter/material.dart';
import '../../models/cart_item.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late List<CartItem> cartItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    cartItems = ModalRoute.of(context)!.settings.arguments as List<CartItem>;
  }

  @override
  Widget build(BuildContext context) {
    int totalKeseluruhan = cartItems.fold(0, (sum, item) => sum + item.total);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            CartItem item = cartItems[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Rp${item.price}",
                          style: const TextStyle(color: Colors.red),
                        ),
                        Text(
                          "Total: Rp${item.total}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _qtyButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (item.qty > 1) {
                            setState(() => item.qty--);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          item.qty.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      _qtyButton(
                        icon: Icons.add,
                        onTap: () {
                          setState(() => item.qty++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // ================= BOTTOM BAR BAYAR =================
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/payment',
            arguments: {'cart': cartItems, 'total': totalKeseluruhan},
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bayar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Rp$totalKeseluruhan",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6), // radius sedikit
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 14, // icon diperkecil
        ),
      ),
    );
  }
}
