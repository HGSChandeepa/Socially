import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/services/users/user_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> _userFuture;
  bool _isLoading = true;
  bool _hasError = false;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = AuthService().getCurrentUser()?.uid ?? '';
    // Fetch user details
    _userFuture = _fetchUserDetails();
  }

  Future<User?> _fetchUserDetails() async {
    try {
      final userId = AuthService().getCurrentUser()?.uid ?? '';
      final user = await UserService().getUserById(userId);

      print('User: ${user?.userId} and ${userId}');
      setState(() {
        _isLoading = false;
        if (user == null) {
          _hasError = true;
        }
      });
      return user;
    } catch (error) {
      print('Error fetching user details: $error');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return null;
    }
  }

  void _signOut(BuildContext context) async {
    await AuthService().signOut();
    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_hasError) {
            return const Center(child: Text('Error loading profile'));
          }
          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundImage: user.imageUrl.isNotEmpty
                    ? NetworkImage(user.imageUrl)
                    : const AssetImage('assets/logo.png') as ImageProvider,
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                user.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // User Bio
              Text(
                user.jobTitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Stats (Posts, Followers, Following)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatColumn('Posts', "2"),
                  _buildStatColumn('Followers', "2"),
                  _buildStatColumn('Following', "2"),
                ],
              ),
              const SizedBox(height: 16),
              // Follow Button (conditional visibility)
              if (user.userId != _currentUserId)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle follow/unfollow logic
                    },
                    child: const Text('Follow'),
                  ),
                ),
              const SizedBox(height: 16),
              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () => _signOut(context),
                  child: const Text('Log Out'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build stats column
  Widget _buildStatColumn(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
