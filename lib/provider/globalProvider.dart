import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/services/httpService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GlobalProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  List<ProductModel> cartItems = [];
  List<ProductModel> favoriteItems = [];
  int currentIndex = 0;
  String? token = "";
  UserModel? currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final CollectionReference _cartCollection = FirebaseFirestore.instance.collection('carts');

  // Method to fetch cart items from Firestore
Future<void> fetchCart(String userId) async {
  try {
    QuerySnapshot snapshot = await _cartCollection.doc(userId).collection('items').get();
    cartItems = snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    notifyListeners();
  } catch (error) {
    print('Error fetching cart: $error');
  }
}


  // Method to add cart item to Firestore
  Future<void> addToCartFirestore(ProductModel item, String userId) async {
    try {
      await _cartCollection.doc(userId).collection('items').doc(item.title).set(item.toJson());

    } catch (error) {
      print('Error adding item to cart: $error');
    }
  }

  // Method to delete cart item from Firestore
Future<void> removeFromCartFirestore(ProductModel item, String userId) async {
  try {
    await _cartCollection.doc(userId).collection('items').doc(item.title).delete();
  } catch (error) {
    print('Error removing item from cart: $error');
  }
}


  GlobalProvider() {
    _initializeFCM();
  }

  void _initializeFCM() async {
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message data: ${message.data}");
      if (message.notification != null) {
        print("Notification: ${message.notification!.title}, ${message.notification!.body}");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked!");
    });
  }

  void setProducts(List<ProductModel> data) {
    products = data;
    notifyListeners();
  }

 void addCartItem(ProductModel data, String userId) {
  addToCartFirestore(data, userId); // Add item to Firestore
  if (cartItems.any((e) => e.id == data.id))
    cartItems.removeWhere((e) => e.id == data.id);
  else
    cartItems.add(data);
  notifyListeners();
}


void removeCartItem(ProductModel data, String email) {
  removeFromCartFirestore(data, email); // Remove item from Firestore
  cartItems.removeWhere((e) => e.id == data.id);
  notifyListeners();
}


  UserModel? getCurrentUser(){
    return currentUser;
  }

  void incrementCount(ProductModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.title == item.title);

    if (index != -1) {
      cartItems[index].count++;
      notifyListeners();
    }
  }

  void decrementCount(ProductModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.title == item.title);

    if (index != -1) {
      cartItems[index].count--;
      notifyListeners();
    }
  }

  void setFavorite(ProductModel item) async {
    int index = products.indexWhere((product) => product.title == item.title);

    if (index != -1) {
      products[index].isFavorite = !products[index].isFavorite;
      int favIndex = favoriteItems.indexWhere((favItem) => favItem.title == item.title);

      if (products[index].isFavorite) {
        if (favIndex == -1) {
          favoriteItems.add(products[index]);
          await _addFavoriteToFirebase(products[index]);
        }
      } else {
        if (favIndex != -1) {
          favoriteItems.removeAt(favIndex);
          await _removeFavoriteFromFirebase(products[index]);
        }
      }

      notifyListeners();
    }
  }

  bool isFavorite(ProductModel item) {
    return item.isFavorite;
  }

  void removeFavorite(ProductModel item) async {
    favoriteItems.removeWhere((favItem) => favItem.id == item.id);
    int index = products.indexWhere((product) => product.id == item.id);
    if (index != -1) {
      products[index].isFavorite = false;
      await _removeFavoriteFromFirebase(products[index]);
    }
    notifyListeners();
  }

  void changeCurrentIdx(int idx) {
    currentIndex = idx;
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  void setCurrentUser(UserModel? user) {
    currentUser = user;
    notifyListeners();
  }

  Future<void> postCart() async {
    if (currentUser == null) return;

    final url = 'carts';
    final cartData = {
      'userId': currentUser!.email,
      'products': cartItems
          .map((item) => {
                'productId': item.id,
                'quantity': item.count,
              })
          .toList(),
    };

    try {
      final response = await HttpService().postData(url, token, cartData);

      if (response.statusCode == 201) {
        clearCart();
      } else {
        print('Failed to post cart: ${response.body}');
      }
    } catch (error) {
      print('Error posting cart: $error');
    }
  }

  void updateCartItems(List<ProductModel> updatedCartItems) {
    cartItems = updatedCartItems;
    notifyListeners();
  }

  Future<void> _addFavoriteToFirebase(ProductModel product) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(currentUser!.email)
          .collection('items')
          .doc(product.title)
          .set(product.toJson()); // Use the toJson method here
    } catch (error) {
      print('Error adding favorite to Firebase: $error');
    }
  }

  Future<void> _removeFavoriteFromFirebase(ProductModel product) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(currentUser!.email)
          .collection('items')
          .doc(product.title)
          .delete();
    } catch (error) {
      print('Error removing favorite from Firebase: $error');
    }
  }

Future<void> fetchFavoriteItems(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('items')
          .get();

      favoriteItems = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching favorite items: $error');
    }
  }

  void addComment(ProductModel product, CommentModel comment) {
    int index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index].comments.add(comment);
      notifyListeners();
    }
  }
}
