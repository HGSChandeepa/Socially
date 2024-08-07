import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/services/auth/auth_service.dart';
import 'package:socially/views/main_screen.dart';
import 'package:socially/widgets/reusable/custom_button.dart';
import 'package:socially/widgets/reusable/custom_input.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sign in with Google

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await AuthService().signInWithGoogle();

      // Navigate to MainPage only if sign-in is successful
      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error signing in with Google: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ReusableInput(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ReusableInput(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ReusableButton(
                  text: 'Log in',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Process the login
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Login')),
                      );
                    }
                  },
                ),

                // Google Sign-In Button

                ReusableButton(
                  text: 'Sign in with Google',
                  onPressed: () {
                    try {
                      _signInWithGoogle(context);
                    } catch (e) {
                      print('Error signing in with Google: $e');
                    }
                  },
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Navigate to signup screen
                    GoRouter.of(context).go('/register');
                  },
                  child: const Text('Don\'t have an account? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
