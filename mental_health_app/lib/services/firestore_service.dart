import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveMood(String mood) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _firestore.collection("moods").add({
      "uid": user.uid,
      "mood": mood,
      "time": FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getMoods() {
    final user = FirebaseAuth.instance.currentUser;

    return _firestore
        .collection("moods")
        .where("uid", isEqualTo: user!.uid)
        .orderBy("time", descending: true)
        .snapshots();
  }

  static Future<void> deleteMood(String id) async {
    await _firestore.collection("moods").doc(id).delete();
  }
}