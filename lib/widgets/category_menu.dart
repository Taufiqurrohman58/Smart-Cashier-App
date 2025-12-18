import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  final List<String> categories;
  final bool isLoading;
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const CategoryMenu({
    super.key,
    this.categories = const ["Semua", "Makanan", "Minuman", "Snack"],
    this.isLoading = false,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: isLoading ? 4 : categories.length, // Show 4 loading chips
        itemBuilder: (context, index) {
          if (isLoading) {
            return _loadingChip();
          }
          return GestureDetector(
            onTap: () => onIndexChanged(index),
            child: _chip(categories[index], selectedIndex == index),
          );
        },
      ),
    );
  }

  Widget _chip(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Chip(
        backgroundColor: active
            ? const Color(0xFF1D1D1F)
            : Colors.grey.shade200,
        label: Text(
          text,
          style: TextStyle(color: active ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _loadingChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Chip(
        backgroundColor: Colors.grey.shade300,
        label: SizedBox(width: 60, height: 16),
      ),
    );
  }
}
