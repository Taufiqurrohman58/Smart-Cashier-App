import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/transaction_history.dart';
import 'home_screen.dart';
import 'report_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int selectedDrawerIndex = 1; // History is active

  List<TransactionHistory> transactions = [];
  bool isLoading = true;
  String errorMessage = '';
  String userRole = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchHistory();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userRole = prefs.getString('user_role') ?? 'Role';
    });
  }

  Future<void> _fetchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          errorMessage = 'Token tidak ditemukan';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/history/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          transactions = data
              .map((json) => TransactionHistory.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memuat history (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      drawer: _buildDrawer(),
      appBar: AppBar(
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
                "History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : transactions.isEmpty
          ? const Center(child: Text('Tidak ada transaksi'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _transactionCard(transaction);
              },
            ),
    );
  }

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      userRole,
                      style: const TextStyle(color: Colors.white70),
                    ),
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
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
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

  Widget _transactionCard(TransactionHistory transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.invoice,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transaction.createdAt,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Kasir
          Text(
            'Kasir: ${transaction.kasir}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),

          // Items
          ...transaction.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.name} x${item.qty}'),
                  Text('Rp${item.subtotal}'),
                ],
              ),
            ),
          ),

          const Divider(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp${transaction.total}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Bayar'), Text('Rp${transaction.uangBayar}')],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kembalian'),
              Text(
                'Rp${transaction.kembalian}',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
