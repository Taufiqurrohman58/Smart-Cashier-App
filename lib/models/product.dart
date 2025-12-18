class Product {
  final int id;
  final String name;
  final String price;
  final String image;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.category = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      image: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }
}
