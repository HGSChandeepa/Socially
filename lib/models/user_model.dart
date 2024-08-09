import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String jobTitle;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;
  final int followers;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.jobTitle,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
    required this.followers,
  });

  // Convert a User instance to a map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'jobTitle': jobTitle,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'password': password,
      'followers': followers,
    };
  }

  // Create a User instance from a map (for retrieving from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      password: map['password'] ?? '',
      followers: map['followers'] ?? 0,
    );
  }
}
