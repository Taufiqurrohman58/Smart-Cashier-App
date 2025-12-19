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
          _drawerItem(icon: Icons.money_off, title: "Laporan", index: 2),
          _drawerItem(icon: Icons.inventory, title: "Kelola Stok", index: 3),
          _drawerItem(icon: Icons.data_object, title: "Master Data", index: 4),
          _drawerItem(icon: Icons.insights, title: "AI Insight", index: 6),
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
