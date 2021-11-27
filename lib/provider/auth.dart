import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

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
    final response = await http.post(Uri.parse(url),
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    print(response.body);
  }
}