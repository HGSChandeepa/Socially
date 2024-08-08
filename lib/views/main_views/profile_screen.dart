import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/services/auth/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final String profilePictureUrl =
      ''; // Replace with actual profile picture URL
  // final String userName = 'John Doe';
  final String userBio = 'Flutter Developer | Tech Enthusiast';

  //sign out method
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture

          // User Name
          Text(
            AuthService().getCurrentUser()?.uid ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // User Bio
          Text(
            userBio,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Stats (Posts, Followers, Following)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatColumn('Posts', '123'),
              _buildStatColumn('Followers', '456'),
              _buildStatColumn('Following', '789'),
            ],
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
