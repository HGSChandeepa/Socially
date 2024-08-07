import 'package:cloud_firestore/cloud_firestore.dart';

class Reel {
  final String caption;
  final String videoUrl;
  final String userId;
  final String username;
  final String reelId;
  final DateTime datePublished;

  Reel({
    required this.caption,
    required this.videoUrl,
    required this.userId,
    required this.username,
    required this.reelId,
    required this.datePublished,
  });

  // Convert a Reel instance to a map (for saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'videoUrl': videoUrl,
      'userId': userId,
      'username': username,
      'reelId': reelId,
      'datePublished': Timestamp.fromDate(datePublished),
    };
  }

  // Create a Reel instance from a map (for retrieving from Firestore)
  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      caption: json['caption'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      reelId: json['reelId'] ?? '',
      datePublished: (json['datePublished'] as Timestamp).toDate(),
    );
  }
}
