import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.qty);

  int get subtotal => _cartItems.fold(0, (sum, item) => sum + (int.parse(item.product.price) * item.qty));

  void addItem(Product product, int qty) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].qty += qty;
    } else {
      _cartItems.add(CartItem(product: product, qty: qty));
    }
    notifyListeners();
  }

  void updateQty(int index, int newQty) {
    if (newQty <= 0) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index].qty = newQty;
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}