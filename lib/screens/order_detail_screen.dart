import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late int qty;
  late int price;
  late String title;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    qty = args['qty'];
    price = args['price'];
    title = args['title'];
  }

  @override
  Widget build(BuildContext context) {
    int totalBayar = qty * price;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1F),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
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
        child: Column(
          children: [
            // ================= CARD ITEM =================
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center, // TENGAH VERTIKAL
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          "assets/images/kopi.png",
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 12),

      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Rp$price",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),

      // ========= QTY CONTROL DI TENGAH KANAN =========
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _qtyButton(
            icon: Icons.remove,
            onTap: () {
              if (qty > 1) {
                setState(() => qty--);
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              qty.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          _qtyButton(
            icon: Icons.add,
            onTap: () {
              setState(() => qty++);
            },
          ),
        ],
      ),
    ],
  ),
)

          ],
        ),
      ),

      // ================= BOTTOM BAR BAYAR =================
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/payment'); 
          // Ganti '/payment' sesuai route page pembayaran kamu
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
                    "Rp$totalBayar",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
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
