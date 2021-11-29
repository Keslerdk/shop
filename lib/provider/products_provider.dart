import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shop/models/http_exceptions.dart';
import 'package:shop/provider/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> localItems = [
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

  String? authToken;
  String? userId;

  ProductsProvider.update(
      {required this.localItems,
      required this.authToken,
      required this.userId});

  ProductsProvider();

  var isShowFavouritesOnly = false;

  List<Product> get items {
    return [...localItems];
  }

  List<Product> get favouriteItems {
    return [...localItems.where((product) => product.isFavourite == true)];
  }

  Product findById(String id) {
    return localItems.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) {
    final url =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    return http
        .post(Uri.parse(url),
            body: json.encode({
              "title": product.title,
              "price": product.price,
              "description": product.description,
              "imageUrl": product.imageUrl,
              "creatorId": userId,
            }))
        .then((response) {
      final newProduct = Product(
        id: json.decode(response.body)["name"],
        imageUrl: product.imageUrl,
        price: product.price,
        description: product.description,
        title: product.title,
      );
      localItems.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = localItems.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      String url =
          "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(Uri.parse(url),
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl": newProduct.imageUrl
          }));
      localItems[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    String url =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    final existingIndex = localItems.indexWhere((prod) => prod.id == id);
    Product? existingProduct = localItems[existingIndex];

    localItems.removeWhere((prod) => prod.id == id);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      localItems.insert(existingIndex, existingProduct);
      notifyListeners();
      throw HttpExceptions(message: "Couldn't delete this product");
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetData([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    final url =
        'https://flutter-lesson-6e435-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    final url2 =
        "https://flutter-lesson-6e435-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final favouriteResponse = await http.get(Uri.parse(url2));
      final favouriteData =
          json.decode(favouriteResponse.body) as Map<String, dynamic>?;
      if (extractedData.isEmpty) return;
      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData["title"],
          price: prodData["price"],
          imageUrl: prodData["imageUrl"],
          description: prodData["description"],
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
        ));
      });
      localItems = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
