import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exceptions.dart';

class Auth with ChangeNotifier {
  String? _token = null;
  DateTime? _expiryDate = null;
  String? _userId = null;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> _authenticate(
      String email, String password, String segment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyAR1FHXUs6CvpXT621nHw7NYbVJsdnTOIc";

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData["error"] != null) {
        throw HttpExceptions(message: responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      notifyListeners();
      print(response.body);
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
