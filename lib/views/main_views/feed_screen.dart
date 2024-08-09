import 'package:flutter/material.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/utils/app_constants/colors.dart';
import 'package:socially/widgets/main/feed/post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  //handle post delete

  Future<void> _deletePost(
      String postId, String postUrl, BuildContext context) async {
    try {
      await FeedService().deletePost(
        postId: postId,
        postUrl: postUrl,
      );

      //show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post deleted successfully'),
        ),
      );
    } catch (e) {
      print('Error deleting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting post'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Post>>(
        stream: FeedService().getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Column(
                children: [
                  PostWidget(
                    post: post,
                    currentUserId: AuthService().getCurrentUser()!.uid,
                    onEdit: () {},
                    onDelete: () async {
                      await _deletePost(post.postId, post.postUrl, context);
                    },
                  ),
                  Divider(
                    color: mainWhiteColor.withOpacity(0.1),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }

  getUserPosts(String userId) {}
}
