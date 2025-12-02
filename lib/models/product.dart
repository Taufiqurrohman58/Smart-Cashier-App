class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final bool isRecommended;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isRecommended = false,
  });

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? 'Unknown Product',
      price: _parsePrice(json['price']),
      imageUrl: json['image'] ?? '',
      category: json['category'] ?? 'unknown',
      isRecommended: json['is_recommended'] ?? false,
    );
  }
}
