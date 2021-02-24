import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  String _authToken;
  String _userId;
  void update(String token, String uId) {
    _authToken = token;
    _userId = uId;
  }

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    //this retyrn only product when isfavorite is true
    return _items.where((proItem) => proItem.isFavorite).toList();
  }

  Product getById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  Future<void> fetchAndEstProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="createdId"&equalTo="$_userId"' : '';
    var url =
        'https://flutterapp-5250e-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString';

    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://flutterapp-5250e-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken';

      final favoriteResponse = await http.get(url);
      
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            description: prodData['description'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
          // double ?? for check if favoriteData[prodId] ==null
          // we get isFavorite alone becouse isFavorite not a part of stored product in db
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // dart send arequest but does not wait the response to execute the next statement
    //but if we need to wait response we put our statements in then methoud
    final url =
        'https://flutterapp-5250e-default-rtdb.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          },
        ),
      );

      final newProduct = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          id: DateTime.now().toString(),
          isFavorite: product.isFavorite);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    // note we did not use const url her becouse of the id in the url
    final url =
        'https://flutterapp-5250e-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';

    await http.patch(
      url,
      body: json.encode(
        {
          'title': newProduct.title,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
          'description': newProduct.description,
        },
      ),
    );
    _items[productIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    final url =
        'https://flutterapp-5250e-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken';

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('can not delete this item');
      }
      existingProduct = null;
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
