import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late int total;
  int bayar = 50000;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    total = ModalRoute.of(context)!.settings.arguments as int;
  }

  @override
  Widget build(BuildContext context) {
    int kembalian = bayar - total;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Pembayaran"),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _totalCard(),
          const SizedBox(height: 12),
          _paymentMethod(),
          const SizedBox(height: 12),
        ],
      ),

      // ================= BOTTOM BAR =================
      bottomNavigationBar: GestureDetector(
        onTap: _prosesPembayaran,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bayar  →",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Kembali Rp$kembalian",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TOTAL CARD =================
  Widget _totalCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _rowTotal("Total", total),
          const SizedBox(height: 6),
          _rowTotal("Jumlah Bayar (Tunai)", bayar),
        ],
      ),
    );
  }

  Widget _rowTotal(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text("Rp$value", style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ================= PAYMENT METHOD =================
  Widget _paymentMethod() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Metode Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          const Text("Tunai"),

          const SizedBox(height: 12),

          _moneyButton(20000),
          _moneyButton(40000),
          _moneyButton(50000),
          _moneyButton(60000),
          _moneyButton(100000),

          const SizedBox(height: 10),

          const Text("Jumlah Lain"),
          const SizedBox(height: 6),

          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Masukkan nominal",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  bayar = int.parse(val);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _moneyButton(int nominal) {
    bool selected = bayar == nominal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Rp$nominal"),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selected ? Colors.teal : Colors.grey.shade300,
              foregroundColor: selected ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                bayar = nominal;
              });
            },
            child: Text(selected ? "Terpilih" : "Pilih"),
          ),
        ],
      ),
    );
  }

  // ================= PROSES PEMBAYARAN =================
  void _prosesPembayaran() async {
    if (bayar < total) {
      _showToast("Uang tidak mencukupi");
      return;
    }

    try {
      // ===============================
      // SIMULASI API BACKEND
      // Ganti nanti dengan API asli
      // ===============================
      await Future.delayed(const Duration(seconds: 1));

      bool backendError = false; // UBAH true untuk test error

      if (backendError) {
        throw Exception("Server sedang bermasalah");
      }

      // ===============================
      // JIKA BERHASIL
      // ===============================
      _showSuccessDialog();
    } catch (e) {
      _showToast(e.toString().replaceAll("Exception:", "").trim());
    }
  }

  // ================= TOAST =================
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ================= SUCCESS DIALOG =================
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 80, color: Colors.teal),

                const SizedBox(height: 12),

                const Text(
                  "Pembayaran Berhasil",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text("Total: Rp$total", style: const TextStyle(fontSize: 14)),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showToast("Struk berhasil dicetak");
                        },
                        child: const Text("Cetak Struk"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Selesai"),
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
  }
}
