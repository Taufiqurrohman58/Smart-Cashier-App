class Product {
  final int id;
  final String name;
  final String category;
  final String price;
  final String image;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
      image: json['image'],
      isActive: json['is_active'],
    );
  }
}
