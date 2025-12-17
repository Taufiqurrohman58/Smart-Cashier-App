class TransferStokResponse {
  final String message;
  final ProductStok product;

  TransferStokResponse({
    required this.message,
    required this.product,
  });

  factory TransferStokResponse.fromJson(Map<String, dynamic> json) {
    return TransferStokResponse(
      message: json['message'] ?? '',
      product: ProductStok.fromJson(json['product'] ?? {}),
    );
  }
}

class GudangStokResponse {
  final String message;
  final GudangProduct product;

  GudangStokResponse({required this.message, required this.product});

  factory GudangStokResponse.fromJson(Map<String, dynamic> json) {
    return GudangStokResponse(
      message: json['message'],
      product: GudangProduct.fromJson(json['product']),
    );
  }
}

class ProductStok {
  final int id;
  final String name;
  final int stockGudang;
  final int stockKantin;

  ProductStok({
    required this.id,
    required this.name,
    required this.stockGudang,
    required this.stockKantin,
  });

  factory ProductStok.fromJson(Map<String, dynamic> json) {
    return ProductStok(
      id: json['id'],
      name: json['name'],
      stockGudang: json['stock_gudang'],
      stockKantin: json['stock_kantin'],
    );
  }
}

class GudangProduct {
  final int id;
  final String name;
  final String category;
  final String price;
  final int stockGudang;
  final String satuan;
  final String? image; 
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  GudangProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stockGudang,
    required this.satuan,
    this.image,               // ✅ nullable
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GudangProduct.fromJson(Map<String, dynamic> json) {
    return GudangProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: json['price']?.toString() ?? '0',
      stockGudang: json['stock_gudang'] ?? 0,
      satuan: json['satuan'] ?? 'pcs',     // ✅ DEFAULT VALUE
      image: json['image'],                // ✅ boleh null
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}