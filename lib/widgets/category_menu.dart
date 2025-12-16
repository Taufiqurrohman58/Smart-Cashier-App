import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const CategoryMenu({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  final List<String> categories = const [
    "Semua",
    "Makanan",
    "Minuman",
    "Snack",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
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
}
