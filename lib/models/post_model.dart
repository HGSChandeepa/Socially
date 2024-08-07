// post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/utils/util_functions/mood.dart';

class Post {
  final String postCaption;
  final Mood mood;
  final String userId;
  final String username;
  final int likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  Post({
    required this.postCaption,
    required this.mood,
    required this.userId,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  // Convert a Post instance to a map (for saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'postCaption': postCaption,
      'mood': mood.name, // Use enum name
      'userId': userId,
      'username': username,
      'likes': likes,
      'postId': postId,
      'datePublished': Timestamp.fromDate(datePublished),
      'postUrl': postUrl,
      'profImage': profImage,
    };
  }

  // Create a Post instance from a map (for retrieving from Firestore)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postCaption: json['postCaption'] ?? '',
      mood: MoodExtension.fromString(json['mood'] ?? 'happy'),
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      likes: json['likes'] ?? 0,
      postId: json['postId'] ?? '',
      datePublished: (json['datePublished'] as Timestamp).toDate(),
      postUrl: json['postUrl'] ?? '',
      profImage: json['profImage'] ?? '',
    );
  }
}
