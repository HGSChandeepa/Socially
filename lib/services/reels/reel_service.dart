// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/models/reel_model.dart';
import 'package:socially/services/reels/reel_storage.dart';

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
        userId: 'user-id-placeholder', 
        username: 'username-placeholder', 
        reelId: '',
        datePublished: DateTime.now(),
      );

      final docRef = await _reelsCollection.add(reel.toJson());
      await docRef.update({'reelId': docRef.id});
    } catch (e) {
      print(e);
    }
  }

  // Delete a reel from Firestore
  Future<void> deleteReel(Reel reel) async {
    try {
      await _reelsCollection.doc(reel.reelId).delete();
      // Delete the reel from Firebase Storage
      await ReelStorageService().deleteVideo(videoUrl: reel.videoUrl);
    } catch (e) {
      print(e);
    }
  }
}
