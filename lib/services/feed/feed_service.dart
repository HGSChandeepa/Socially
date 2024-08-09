import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/services/feed/feed_storage.dart';
import 'package:socially/utils/util_functions/mood.dart';

class FeedService {
  // Create a collection reference
  final CollectionReference _feedCollection =
      FirebaseFirestore.instance.collection('feed');

  // Save the post in the Firestore database
  Future<void> savePost(Map<String, dynamic> postDetails) async {
    try {
      String? postUrl;

      // Check if the post has an image
      if (postDetails['postImage'] != null &&
          postDetails['postImage'] is File) {
        postUrl = await FeedStorageService().uploadImage(
          postImage: postDetails['postImage'] as File,
          userId: postDetails['userId'] as String,
        );
      }

      // Create a new Post object
      final Post post = Post(
        postCaption: postDetails['postCaption'] as String? ?? '',
        mood: MoodExtension.fromString(postDetails['mood'] ?? 'happy'),
        userId: postDetails['userId'] as String? ?? '',
        username: postDetails['username'] as String? ?? '',
        likes: 0,
        postId: '', // This will be updated after adding to Firestore
        datePublished: DateTime.now(),
        postUrl: postUrl ?? '',
        profImage: postDetails['profImage'] as String? ?? '',
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

  // Delete a post from the Firestore database
  Future<void> deletePost(
      {required String postId, required String postUrl}) async {
    try {
      await _feedCollection.doc(postId).delete();
      await FeedStorageService().deleteImage(imageUrl: postUrl);
      print("Post deleted successfully");
    } catch (error) {
      print('Error deleting post: $error');
    }
  }

  //get all posts images form the user
  Future<List<String>> getUserPosts(String userId) async {
    try {
      final userPosts = await _feedCollection
          .where('userId', isEqualTo: userId)
          .get()
          .then((snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });

      return userPosts.map((post) => post.postUrl).toList();
    } catch (error) {
      print('Error fetching user posts: $error');
      return [];
    }
  }

  // for each post i want a new collection called postLikes and i want to store the number of likes in that collection

  //create a methode to like a post
  Future<void> likePost(
      {required String postId, required String userId}) async {
    try {
      final postLikesRef =
          _feedCollection.doc(postId).collection('likes').doc(userId);

      // Add a document to the likes subcollection
      await postLikesRef.set({'likedAt': Timestamp.now()});

      // Update the likes count in the post document
      final postDoc = await _feedCollection.doc(postId).get();
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      final newLikesCount = post.likes + 1;

      await _feedCollection.doc(postId).update({'likes': newLikesCount});

      print('Post liked successfully');
    } catch (error) {
      print('Error liking post: $error');
    }
  }

  //create a methode to unlike a post
  // Unlike a post
  Future<void> unlikePost(
      {required String postId, required String userId}) async {
    try {
      final postLikesRef =
          _feedCollection.doc(postId).collection('likes').doc(userId);

      // Delete the document from the likes subcollection
      await postLikesRef.delete();

      // Update the likes count in the post document
      final postDoc = await _feedCollection.doc(postId).get();
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      final newLikesCount = post.likes - 1;

      await _feedCollection.doc(postId).update({'likes': newLikesCount});

      print('Post unliked successfully');
    } catch (error) {
      print('Error unliking post: $error');
    }
  }

  // Check if a user has liked a post
  Future<bool> hasUserLikedPost(
      {required String postId, required String userId}) async {
    try {
      final postLikesRef =
          _feedCollection.doc(postId).collection('likes').doc(userId);

      // Check if the like document exists
      final doc = await postLikesRef.get();
      return doc.exists;
    } catch (error) {
      print('Error checking if user liked post: $error');
      return false;
    }
  }
}
