import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'card.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CardItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String _authToken;
  String _userId;
  void update(String token, String uId) {
    _authToken = token;
    _userId = uId;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutterapp-5250e-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (itrm) => CardItem(
                id: itrm['id'],
                price: itrm['price'],
                quantity: itrm['quantity'],
                title: itrm['title'],
              ),
            )
            .toList(),
      ));
    });
    //we use reversed to make the orders oldest first
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CardItem> cardProducts, double total) async {
    final url =
        'https://flutterapp-5250e-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final timeStamb = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamb.toIso8601String(),
          'products': cardProducts
              .map(
                (cp) => {
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                },
              )
              .toList()
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cardProducts,
        dateTime: timeStamb,
      ),
    );
  }
}
