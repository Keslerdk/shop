import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({required this.id,
    required this.title,
    required this.quantity,
    required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return items.length;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
              (existingCardItem) =>
              CartItem(
                  id: existingCardItem.id,
                  title: existingCardItem.title,
                  quantity: existingCardItem.quantity + 1,
                  price: existingCardItem.price));
    } else {
      _items.putIfAbsent(
          productId,
              () =>
              CartItem(
                  id: DateTime.now().toString(),
                  title: title,
                  quantity: 1,
                  price: price));
    }
    notifyListeners();
  }

  double get totalAmount {
    double sum = 0;
    _items.forEach((key, value) {
      sum += value.price * value.quantity;
    });
    return sum;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (prod) =>
          CartItem(id: prod.id,
              title: prod.title,
              quantity: prod.quantity - 1,
              price: prod.price
          ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
