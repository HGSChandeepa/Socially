// ignore_for_file: avoid_print

import 'package:firebase_storage/firebase_storage.dart';

class UserProfileStorageService {
  //Firebase storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage({
    required profileImage,
    required userEmail,
  }) async {
    Reference ref = _storage
        .ref()
        .child("user-images")
        .child("$userEmail/${DateTime.now()}");

    try {
      UploadTask task = ref.putFile(
        profileImage,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return "";
    }
  }
}
