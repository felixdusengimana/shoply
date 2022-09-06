import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  DateTime _expireDate = DateTime.now();
  String _userId = '';
  Timer? _authTimer;

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
        _autoLogout();
        notifyListeners();
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expireDate': _expireDate.toIso8601String(),
        });
        prefs.setString('userData', userData);
      } else {
        final data = json.decode(resp.body);
        throw HttpException(data['error']['message']);
      }
    } catch (error) {
      print(error.toString());
      throw HTTPException(error.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = '';
    _userId = '';
    _expireDate = DateTime.now();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('userData')) {
        return false;
      }
      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, Object>;
      final expireDate =
          DateTime.parse(extractedUserData['expireDate'] as String);
      if (expireDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = extractedUserData['token'] as String;
      _userId = extractedUserData['userId'] as String;
      _expireDate = expireDate;
      _autoLogout();
      notifyListeners();
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future<void> _autoLogout() async {
    // final prefs = await SharedPreferences.getInstance();
    final timeToExpire = _expireDate.difference(DateTime.now()).inSeconds;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    _authTimer = Timer(Duration(seconds: timeToExpire), () {
      logout();
    });
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // prefs.setString(
    //   'userData',
    //   json.encode({
    //     'token': _token,
    //     'userId': _userId,
    //     'expireDate': _expireDate.toIso8601String(),
    //   }),
    // );
  }
}
