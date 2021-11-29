import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/http_exceptions.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

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

  String? get userId {
    return _userId;
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
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String()
      });
      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _userId = null;
    _expiryDate = null;
    _token = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer!.cancel();
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) return false;
    final extractedUserData = json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = extractedUserData["token"];
    _expiryDate = expiryDate;
    _userId = extractedUserData["userId"];
    notifyListeners();
    _autoLogout();
    return true;
  }
}
