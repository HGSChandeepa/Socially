import 'package:flutter/material.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/widgets/reusable/custom_button.dart';

class SingleUserScreen extends StatefulWidget {
  final UserModel user;

  SingleUserScreen({required this.user});

  @override
  _SingleUserScreenState createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends State<SingleUserScreen> {
  late Future<List<String>> _userPosts;
  late Future<bool> _isFollowing;
  late UserService _userService;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _currentUserId = AuthService().getCurrentUser()!.uid;
    _userPosts = FeedService().getUserPosts(widget.user.userId);
    _isFollowing = _userService.isFollowing(_currentUserId, widget.user.userId);
  }

  Future<void> _toggleFollow() async {
    try {
      final isFollowing = await _isFollowing;

      if (isFollowing) {
        // Unfollow
        await _userService.unfollowUser(_currentUserId, widget.user.userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unfollowed ${widget.user.name}')),
        );
      } else {
        // Follow
        await _userService.followUser(_currentUserId, widget.user.userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Followed ${widget.user.name}')),
        );
      }

      // Update follow status
      setState(() {
        _isFollowing =
            _userService.isFollowing(_currentUserId, widget.user.userId);
      });
    } catch (error) {
      print('Error toggling follow status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.user.imageUrl.isNotEmpty
                      ? NetworkImage(widget.user.imageUrl)
                      : const AssetImage('assets/logo.png') as ImageProvider,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.user.jobTitle,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (widget.user.userId != _currentUserId)
              FutureBuilder<bool>(
                future: _isFollowing,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Error checking follow status');
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  final isFollowing = snapshot.data!;
                  return ReusableButton(
                    onPressed: _toggleFollow,
                    width: MediaQuery.of(context).size.width,
                    text: isFollowing ? 'Unfollow' : 'Follow',
                  );
                },
              ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _userPosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading posts'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No posts available'));
                  }

                  final postImages = snapshot.data!;

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: postImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        postImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
