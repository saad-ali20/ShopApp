import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;

  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
    @required this.description,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url =
          'https://flutterapp-5250e-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (_) {
      print('cant make favorite');
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
