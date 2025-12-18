class TransactionItem {
  final String name;
  final int qty;
  final int subtotal;

  TransactionItem({
    required this.name,
    required this.qty,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      name: json['name'],
      qty: json['qty'],
      subtotal: (json['subtotal'] as num).toInt(),
    );
  }
}

class TransactionHistory {
  final String invoice;
  final int total;
  final int uangBayar;
  final int kembalian;
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
      total: (json['total'] as num).toInt(),
      uangBayar: (json['uang_bayar'] as num).toInt(),
      kembalian: (json['kembalian'] as num).toInt(),
      kasir: json['kasir'],
      createdAt: json['created_at'],
      items: (json['items'] as List)
          .map((e) => TransactionItem.fromJson(e))
          .toList(),
    );
  }
}
