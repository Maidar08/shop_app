import 'package:flutter/material.dart';

class UserModel {
  final String email;
  final String username;

  UserModel({
    required this.email,
    required this.username,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      email: json['email'],
      username: json['username'],
    );
  }
}
