import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shop/models/http_exceptions.dart';
import 'package:shop/provider/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var isShowFavouritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return [..._items.where((product) => product.isFavourite == true)];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) {
    const url =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products.json";
    return http
        .post(Uri.parse(url),
            body: json.encode({
              "title": product.title,
              "price": product.price,
              "description": product.description,
              "imageUrl": product.imageUrl,
              "isFavourite": product.isFavourite
            }))
        .then((response) {
      final newProduct = Product(
        id: json.decode(response.body)["name"],
        imageUrl: product.imageUrl,
        price: product.price,
        description: product.description,
        title: product.title,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      String url =
          "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products/$id.json";
      await http.patch(Uri.parse(url),
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl": newProduct.imageUrl
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    String url =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products/$id.json";
    final existingIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingIndex];

    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
      throw HttpExceptions(message: "Couldn't delete this product");
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetData() async {
    const url =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products.json";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData["title"],
            price: prodData["price"],
            imageUrl: prodData["imageUrl"],
            description: prodData["description"]));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
