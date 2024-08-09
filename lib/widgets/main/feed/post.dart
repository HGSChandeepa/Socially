import 'package:flutter/material.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/utils/app_constants/colors.dart';
import 'package:socially/utils/util_functions/mood.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String currentUserId;

  const PostWidget({
    required this.post,
    required this.onEdit,
    required this.onDelete,
    required this.currentUserId,
    Key? key,
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false; // Track if the post is liked

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  // Check if the user has liked the post
  Future<void> _checkIfLiked() async {
    final hasLiked = await FeedService().hasUserLikedPost(
      postId: widget.post.postId,
      userId: widget.currentUserId,
    );
    setState(() {
      _isLiked = hasLiked;
    });
  }

  // Method to like and dislike a post
  void _likePost() async {
    try {
      if (_isLiked) {
        await FeedService().unlikePost(
          postId: widget.post.postId,
          userId: widget.currentUserId,
        );
        setState(() {
          _isLiked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post unliked'),
          ),
        );
      } else {
        await FeedService().likePost(
          postId: widget.post.postId,
          userId: widget.currentUserId,
        );
        setState(() {
          _isLiked = true;
        });
      }
    } catch (e) {
      print('Error liking/unliking post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: webBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.post.profImage.isEmpty
                        ? 'https://i.stack.imgur.com/l60Hf.png'
                        : widget.post.profImage,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: mainWhiteColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: mainPurpleColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  'Feeling ${widget.post.mood.name} ${widget.post.mood.emoji}',
                  style: const TextStyle(
                    color: mainWhiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.post.postCaption,
              style: TextStyle(
                color: mainWhiteColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            if (widget.post.postUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.post.postUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : mainWhiteColor,
                      ),
                      onPressed: _likePost,
                    ),
                    Text(
                      "${widget.post.likes} likes",
                      style: const TextStyle(color: mainWhiteColor),
                    ),
                  ],
                ),
                if (widget.post.userId == widget.currentUserId)
                  IconButton(
                    onPressed: () {
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                _buildDialogOption(
                                  context: context,
                                  icon: Icons.edit,
                                  text: 'Edit',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    widget.onEdit();
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: mainWhiteColor.withOpacity(0.5),
                                  ),
                                ),
                                _buildDialogOption(
                                  context: context,
                                  icon: Icons.delete,
                                  text: 'Delete',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    widget.onDelete();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert, color: mainWhiteColor),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: mainWhiteColor,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: mainWhiteColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
