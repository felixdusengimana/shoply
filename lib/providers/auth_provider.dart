import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopl/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  DateTime _expireDate = DateTime.now();
  String _userId = '';

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return '';
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:$urlSegment',
        {'key': 'AIzaSyADmsSvVUs711rzfmaLN8x3GTQMUbOUxCE'});
    try {
      final resp = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        _token = data['idToken'];
        _userId = data['localId'];
        _expireDate =
            DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
        notifyListeners();
      } else {
        final data = json.decode(resp.body);
        throw HttpException(data['error']['message']);
      }
    } catch (error) {
      throw HTTPException(error.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
