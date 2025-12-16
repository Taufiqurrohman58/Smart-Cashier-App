class TransactionItem {
  final String name;
  final int qty;
  final String subtotal;

  TransactionItem({
    required this.name,
    required this.qty,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      name: json['name'],
      qty: json['qty'],
      subtotal: json['subtotal'],
    );
  }
}

class TransactionHistory {
  final String invoice;
  final String total;
  final String uangBayar;
  final String kembalian;
  final String kasir;
  final String createdAt;
  final List<TransactionItem> items;

  TransactionHistory({
    required this.invoice,
    required this.total,
    required this.uangBayar,
    required this.kembalian,
    required this.kasir,
    required this.createdAt,
    required this.items,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      invoice: json['invoice'],
      total: json['total'],
      uangBayar: json['uang_bayar'],
      kembalian: json['kembalian'],
      kasir: json['kasir'],
      createdAt: json['created_at'],
      items: (json['items'] as List<dynamic>)
          .map((item) => TransactionItem.fromJson(item))
          .toList(),
    );
  }
}
