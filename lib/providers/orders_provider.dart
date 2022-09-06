import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart_provider.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class OrderProviders with ChangeNotifier {
  final String _baseUrl = 'flutter-demo-7cd5d-default-rtdb.firebaseio.com';
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(_baseUrl, '/orders.json');
    try {
      final data = await http.get(url);
      print(data.statusCode);
      final List<Order> loadedOrders = [];
      if (data.body == 'null') throw Exception();
      final extractedData = json.decode(data.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }

      extractedData.forEach((orderID, orderData) {
        print(orderID);
        loadedOrders.add(Order(
            id: orderID,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(_baseUrl, '/orders.json');
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      print("error");
      throw error;
    }
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
