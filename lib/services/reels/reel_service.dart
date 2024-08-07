import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/models/reel_model.dart';

class ReelService {
  final CollectionReference _reelsCollection =
      FirebaseFirestore.instance.collection('reels');

  // Fetch reels from Firestore
  Stream<QuerySnapshot> getReels() {
    return _reelsCollection.snapshots();
  }

  // Save a reel in Firestore
  Future<void> saveReel(Map<String, dynamic> reelDetails) async {
    try {
      final reel = Reel(
        caption: reelDetails['caption'],
        videoUrl: reelDetails['videoUrl'],
        userId: 'user-id-placeholder', // Replace with actual user ID
        username: 'username-placeholder', // Replace with actual username
        reelId: '',
        datePublished: DateTime.now(),
      );

      final docRef = await _reelsCollection.add(reel.toJson());
      await docRef.update({'reelId': docRef.id});
    } catch (e) {
      print(e);
    }
  }
}
