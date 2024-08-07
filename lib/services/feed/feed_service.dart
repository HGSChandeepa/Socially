// FeedService.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/services/feed/feed_storage.dart';
import 'package:socially/utils/util_functions/mood.dart';

class FeedService {
  // Initialize the Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a collection reference
  final CollectionReference _feedCollection =
      FirebaseFirestore.instance.collection('feed');

  // Save the post in the Firestore database
  Future<void> savePost(Map<String, dynamic> postDetails) async {
    try {
      String? postUrl;

      // Check if the post has an image
      if (postDetails['postImage'] != null) {
        postUrl = await FeedStorageService().uploadImage(
          postImage: postDetails['postImage'],
          userId: postDetails['userId'],
        );
      }

      // Create a new Post object
      final Post post = Post(
        postCaption: postDetails['postCaption'],
        mood: MoodExtension.fromString(
            postDetails['mood'] ?? 'happy'), // Convert String to Mood enum
        userId: postDetails['userId'],
        username: postDetails['username'],
        likes: 0,
        postId: '', // This will be updated after adding to Firestore
        datePublished: DateTime.now(),
        postUrl: postUrl ?? '',
        profImage: postDetails['profImage'],
      );

      // Add the post to the collection
      final docRef = await _feedCollection.add(post.toJson());
      await docRef.update({'postId': docRef.id});
    } catch (error) {
      print('Error saving post: $error');
    }
  }

  // Fetch the posts as a stream
  Stream<List<Post>> getPostsStream() {
    return _feedCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
