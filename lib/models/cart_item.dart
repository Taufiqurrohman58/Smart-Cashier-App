class CartItem {
  final int productId;   // ✅ ID produk dari backend
  final String name;
  final int price;
  int qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.qty = 1,
  });

  int get total => price * qty;
}
