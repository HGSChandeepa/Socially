import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/services/reels/reel_service.dart';
import 'package:socially/services/reels/reel_storage.dart';

class AddReelModal extends StatefulWidget {
  @override
  _AddReelModalState createState() => _AddReelModalState();
}

class _AddReelModalState extends State<AddReelModal> {
  final _captionController = TextEditingController();
  File? _videoFile;

  // Pick a video from the gallery
  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  // Handle video upload and post creation
  void _submitReel() async {
    if (_videoFile != null && _captionController.text.isNotEmpty) {
      try {
        final videoUrl = await ReelStorageService().uploadVideo(
          videoFile: _videoFile!,
        );
        final reelDetails = {
          'caption': _captionController.text,
          'videoUrl': videoUrl,
        };

        await ReelService().saveReel(reelDetails);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reel added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add reel')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _captionController,
            decoration: InputDecoration(
              labelText: 'Caption',
            ),
          ),
          SizedBox(height: 16),
          _videoFile != null
              ? Text('Video selected: ${_videoFile!.path}')
              : Text('No video selected'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickVideo,
            child: Text('Pick Video from Gallery'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitReel,
            child: Text('Submit Reel'),
          ),
        ],
      ),
    );
  }
}
