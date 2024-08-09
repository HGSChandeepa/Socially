import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/services/users/user_service.dart';
import 'package:socially/utils/util_functions/mood.dart';
import 'package:socially/widgets/reusable/custom_button.dart';
import 'package:socially/widgets/reusable/custom_input.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  File? _imageFile;
  Mood _selectedMood = Mood.happy; // Default mood

  // Pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Handle form submission
  void _submitPost() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, handle the submission
      try {
        final postCaption = _captionController.text;

        // Get the current user
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Fetch user details from Firestore
          final userDetails = await UserService().getUserById(user.uid);

          if (userDetails != null) {
            // Create a new post object with user details
            final postDetails = {
              'postCaption': postCaption,
              'mood': _selectedMood.name,
              'userId': user.uid,
              'username': userDetails.name,
              'profImage': userDetails.imageUrl,
              'postImage': _imageFile,
            };

            // Save the post
            await FeedService().savePost(postDetails);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post created successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to fetch user details')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user is currently logged in')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create post')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableInput(
                  controller: _captionController,
                  labelText: 'Caption',
                  icon: Icons.text_fields,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a caption';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButton<Mood>(
                  value: _selectedMood,
                  onChanged: (Mood? newMood) {
                    setState(() {
                      _selectedMood = newMood ?? _selectedMood;
                    });
                  },
                  items: Mood.values.map((Mood mood) {
                    return DropdownMenuItem<Mood>(
                      value: mood,
                      child: Text('${mood.name} ${mood.emoji}'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _imageFile!,
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.5,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Text('No image selected'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableButton(
                      text: 'Use Camera',
                      onPressed: () => _pickImage(ImageSource.camera),
                      width: MediaQuery.of(context).size.width * 0.43,
                    ),
                    const SizedBox(width: 16),
                    ReusableButton(
                      text: 'Use Gallery',
                      onPressed: () => _pickImage(ImageSource.gallery),
                      width: MediaQuery.of(context).size.width * 0.43,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ReusableButton(
                  text: 'Submit Post',
                  onPressed: _submitPost,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
