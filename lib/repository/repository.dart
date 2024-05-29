import 'dart:convert';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/services/httpService.dart';

class MyRepository {
  final HttpService httpService = HttpService();

  MyRepository();

  Future<List<ProductModel>> fetchProductData() async {
    try {
      var jsonData = await httpService.getData('products', null);
      List<ProductModel> data = ProductModel.fromList(jsonData);
      return data;
    } catch (e) {
      // Handle errors
      return Future.error(e.toString());
    }
  }

  Future<String> login(String username, String password) async {
    try {
      dynamic data = {"username": username, "password": password};
      var jsonData = await httpService.postData('auth/login', null, data);
      return jsonData["token"];
    } catch (e) {
      // Handle errors
      return Future.error(e.toString());
    }
  }

  Future<UserModel> getDetails(String token) async {
    try {
      var response = await httpService.getData('users/2', token); // Use 'me' endpoint for current user
      UserModel user = UserModel.fromJson(response);
      return user;
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<List<dynamic>> getCartByUserId(String userId) async {
    try {
      var jsonData = await httpService.getData('carts/$userId', null);
      return jsonData; // Assuming the response is a list of cart objects
    } catch (e) {
      throw Exception('Failed to fetch cart information: $e');
    }
  }
}
