import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    print('token');
    print(token.toString());
    return token != null;
  }
  String get userId {
    return _userId;
  }
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authentication(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAAnGIRCcBLP7TpPjEVIGW6aTl26PUN6N8";
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ));
      print(jsonDecode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print('responseData[]' + responseData['error']['message']);
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }
  void logout(){
    _token = null;
    _userId = null;
    _expiryDate = null;
  notifyListeners();
  }

}
