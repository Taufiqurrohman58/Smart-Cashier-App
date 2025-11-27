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
}