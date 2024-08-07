import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ReelStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload video to Firebase Storage
  Future<String> uploadVideo({required File videoFile}) async {
    try {
      // Generate a unique file name
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      // Create a reference to the video file in Firebase Storage
      Reference ref = _storage.ref().child('reels/$fileName');

      // Upload the file to Firebase Storage
      await ref.putFile(videoFile);

      // Get the download URL for the uploaded file
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      throw e;
    }
  }
}
