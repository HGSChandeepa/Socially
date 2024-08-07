import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/services/feed/feed_service.dart';
import 'package:socially/utils/util_functions/mood.dart';

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
  void _submitPost() {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, handle the submission
      try {
        final postCaption = _captionController.text;
        final moodEmoji = _selectedMood.emoji;

        // Get the current user
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid;
        // TODO: get theese data from the users collection
        final username = user?.displayName;
        final profImage = user?.photoURL;

        // Create a new post object
        // CreateScreen.dart
        final postDetails = {
          'postCaption': postCaption,
          'mood': _selectedMood.name, // Save the mood as the enum name
          'userId': userId,
          'username': username,
          'profImage': profImage,
          'postImage': _imageFile,
        };

        // Save the post
        FeedService().savePost(postDetails);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
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
                TextFormField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    labelText: 'Caption',
                  ),
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
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: const Text('Pick from Camera'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: const Text('Pick from Gallery'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitPost,
                  child: const Text('Submit Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
