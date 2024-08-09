import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/services/reels/reel_service.dart';
import 'package:socially/services/reels/reel_storage.dart';
import 'package:socially/widgets/reusable/custom_button.dart';

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
          const SnackBar(content: Text('Reel added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add reel')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(8),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  labelText: 'Caption',
                ),
              ),
              const SizedBox(height: 16),
              _videoFile != null
                  ? Text('Video selected: ${_videoFile!.path}')
                  : const Text('No video selected'),
              const SizedBox(height: 16),
              ReusableButton(
                onPressed: _pickVideo,
                text: 'Select Video',
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 16),
              ReusableButton(
                onPressed: _submitReel,
                text: 'Add Reel',
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
