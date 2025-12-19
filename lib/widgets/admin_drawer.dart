import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  final String userName;
  final String userRole;
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const AdminDrawer({
    super.key,
    required this.userName,
    required this.userRole,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          ExpansionTile(
            leading: Icon(
              Icons.money_off,
              color: selectedIndex == 2 ? Colors.teal : Colors.grey,
            ),
            title: Text(
              "Laporan",
              style: TextStyle(
                color: selectedIndex == 2 ? Colors.teal : Colors.black,
                fontWeight: selectedIndex == 2
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            children: [
              _drawerItem(
                icon: Icons.calendar_today,
                title: "Laporan Harian",
                index: 7,
              ),
              _drawerItem(
                icon: Icons.calendar_view_month,
                title: "Laporan Bulanan",
                index: 8,
              ),
              _drawerItem(
                icon: Icons.calendar_today,
                title: "Laporan Tahunan",
                index: 9,
              ),
              _drawerItem(
                icon: Icons.money_off,
                title: "Laporan Pengeluaran",
                index: 10,
              ),
              _drawerItem(
                icon: Icons.file_download,
                title: "Export Laporan (Excel & PDF)",
                index: 11,
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(
              Icons.inventory,
              color: selectedIndex == 3 ? Colors.teal : Colors.grey,
            ),
            title: Text(
              "Kelola Stok",
              style: TextStyle(
                color: selectedIndex == 3 ? Colors.teal : Colors.black,
                fontWeight: selectedIndex == 3
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            children: [
              _drawerItem(
                icon: Icons.swap_horiz,
                title: "Transfer Stok",
                index: 15,
              ),
              _drawerItem(icon: Icons.add, title: "Tambah Stok", index: 16),
            ],
          ),
          ExpansionTile(
            leading: Icon(
              Icons.data_object,
              color: selectedIndex == 4 ? Colors.teal : Colors.grey,
            ),
            title: Text(
              "Master Data",
              style: TextStyle(
                color: selectedIndex == 4 ? Colors.teal : Colors.black,
                fontWeight: selectedIndex == 4
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            children: [
              _drawerItem(icon: Icons.inventory, title: "Produk", index: 12),
              _drawerItem(icon: Icons.straighten, title: "Satuan", index: 13),
              _drawerItem(icon: Icons.person, title: "User", index: 14),
            ],
          ),
          ExpansionTile(
            leading: Icon(
              Icons.insights,
              color: selectedIndex == 6 ? Colors.teal : Colors.grey,
            ),
            title: Text(
              "AI Insight",
              style: TextStyle(
                color: selectedIndex == 6 ? Colors.teal : Colors.black,
                fontWeight: selectedIndex == 6
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            children: [
              _drawerItem(
                icon: Icons.trending_up,
                title: "Penjualan Terlaris",
                index: 17,
              ),
              _drawerItem(
                icon: Icons.lightbulb,
                title: "Rekomendasi Stok",
                index: 18,
              ),
              _drawerItem(
                icon: Icons.warning,
                title: "Prediksi Habis",
                index: 19,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    bool active = selectedIndex == index;

    return InkWell(
      onTap: () => onIndexChanged(index),
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
}
