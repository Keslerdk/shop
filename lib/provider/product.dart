import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});

  void _setFavBack(bool value) {
    isFavourite = value;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token) async {
    final oldValue = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({"isFavourite": isFavourite}));
      if (response.statusCode >= 400) _setFavBack(oldValue);
    } catch (error) {
      _setFavBack(oldValue);
    }
  }
}
