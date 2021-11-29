import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> localOrders = [];
  String? authToken;
  String? userId;

  Orders.update(
      {required this.authToken,
      required this.localOrders,
      required this.userId});

  Orders();

  List<OrderItem> get orders {
    return [...localOrders];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timaeStamp = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "amount": total,
            "dateTime": timaeStamp.toIso8601String(),
            "products": cartProduct
                .map((cp) => {
                      "id": cp.id,
                      "title": cp.title,
                      "quantity": cp.quantity,
                      "price": cp.price
                    })
                .toList()
          }));

      localOrders.insert(
          0,
          OrderItem(
              id: json.decode((response.body))['name'],
              amount: total,
              products: cartProduct,
              dateTime: timaeStamp));
      notifyListeners();
    } catch (error) {}
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final List<OrderItem> loadedOrders = [];
      final extractedOrders =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedOrders.isEmpty) return;
      extractedOrders.forEach((orderId, orderData) {
        loadedOrders.insert(
            0,
            OrderItem(
              amount: orderData["amount"],
              dateTime: DateTime.parse(orderData["dateTime"]),
              products: (orderData["products"] as List<dynamic>)
                  .map((cp) => CartItem(
                      price: cp["price"],
                      id: cp["id"],
                      quantity: cp["quantity"],
                      title: cp["title"]))
                  .toList(),
              id: orderId,
            ));
      });
      localOrders = loadedOrders;
      notifyListeners();
    } catch (error) {}
  }
}
