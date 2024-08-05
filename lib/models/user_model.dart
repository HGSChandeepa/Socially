import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a User instance to a map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create a User instance from a map (for retrieving from Firestore)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      confirmPassword: map['confirmPassword'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
