import 'package:flutter/material.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/services/feed/feed_service.dart';

class SingleUserScreen extends StatefulWidget {
  final User user;

  SingleUserScreen({required this.user});

  @override
  _SingleUserScreenState createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends State<SingleUserScreen> {
  late Future<List<String>> _userPosts;

  @override
  void initState() {
    super.initState();
    _userPosts = FeedService().getUserPosts(widget.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: widget.user.imageUrl.isNotEmpty
                ? NetworkImage(widget.user.imageUrl)
                : AssetImage('assets/logo.png') as ImageProvider,
          ),
          const SizedBox(height: 16),
          Text(
            widget.user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.user.jobTitle,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                  return Center(child: Text('Error loading posts'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No posts available'));
                }

                final postImages = snapshot.data!;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
