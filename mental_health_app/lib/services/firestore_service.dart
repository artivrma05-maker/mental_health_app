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
  static Future<Map<String, int>> getMoodCounts() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return {};

  final snapshot = await _firestore
      .collection("moods")
      .where("uid", isEqualTo: user.uid)
      .get();

  Map<String, int> counts = {
    "Happy": 0,
    "Calm": 0,
    "Neutral": 0,
    "Sad": 0,
    "Angry": 0,
  };

  for (var doc in snapshot.docs) {
    String mood = doc["mood"];
    counts[mood] = (counts[mood] ?? 0) + 1;
  }

  return counts;
}
}