class TransferStokResponse {
  final String message;
  final ProductStok product;

  TransferStokResponse({
    required this.message,
    required this.product,
  });

  factory TransferStokResponse.fromJson(Map<String, dynamic> json) {
    return TransferStokResponse(
      message: json['message'],
      product: ProductStok.fromJson(json['product']),
    );
  }
}

class GudangStokResponse {
  final String message;
  final GudangProduct product;

  GudangStokResponse({
    required this.message,
    required this.product,
  });

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
  final int stockGudang;

  GudangProduct({
    required this.id,
    required this.name,
    required this.stockGudang,
  });

  factory GudangProduct.fromJson(Map<String, dynamic> json) {
    return GudangProduct(
      id: json['id'],
      name: json['name'],
      stockGudang: json['stock_gudang'],
    );
  }
}