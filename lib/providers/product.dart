import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final existingStatus = isFavorite;
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      final url = Uri.https('flutter-demo-7cd5d-default-rtdb.firebaseio.com',
          '/userFavorite/$userId/$id.json', {'auth': token});
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        isFavorite = existingStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = existingStatus;
      notifyListeners();
    }
  }
}
