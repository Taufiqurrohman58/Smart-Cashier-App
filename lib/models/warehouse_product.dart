class WarehouseProduct {
  final int id;
  final String name;

  WarehouseProduct({required this.id, required this.name});

  factory WarehouseProduct.fromJson(Map<String, dynamic> json) {
    return WarehouseProduct(id: json['id'], name: json['name']);
  }
}
