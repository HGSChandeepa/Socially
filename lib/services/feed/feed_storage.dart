import 'package:firebase_storage/firebase_storage.dart';

class FeedStorageService {
  //Firebase storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage({required postImage, required userId}) async {
    Reference ref =
        _storage.ref().child("feed-images").child("$userId/${DateTime.now()}");

    try {
      UploadTask task = ref.putFile(
        postImage,
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
