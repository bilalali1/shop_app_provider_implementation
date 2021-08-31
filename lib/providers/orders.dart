
import 'package:flutter/foundation.dart';
import './provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      this.id,
      this.amount,
      this.products,
      this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final  url = 'https://shop-8d5bb-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData != null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            orderId,
            orderData['amount'],
            (orderData['products'] as List<dynamic>).map((item) => CartItem(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
            )).toList(),
            orderData['dateTime']),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final  url = 'https://shop-8d5bb-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();

   final response = await http.post(Uri.parse(url),
    body: json.encode({
      'amount' : total,
      'dateTime' : timestamp.toIso8601String(),
      'products' : cartProducts
            .map((cp) => {
              'id' : cp.id,
              'title' : cp.title,
              'quantity' : cp.quantity,
              'price' : cp.price,
      }).toList(),

    }),
    );
    _orders.insert(0,
        OrderItem(
            json.decode(response.body)['name'],
            total,
            cartProducts,
            timestamp));
    notifyListeners();
  }


}