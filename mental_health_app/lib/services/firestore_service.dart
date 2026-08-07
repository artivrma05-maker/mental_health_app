import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Save Mood
  static Future<void> saveMood(String mood) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _firestore.collection("moods").add({
      "uid": user.uid,
      "mood": mood,
      "time": FieldValue.serverTimestamp(),
    });
  }

  // Get Mood History
  static Stream<QuerySnapshot> getMoods() {
    final user = FirebaseAuth.instance.currentUser;

    return _firestore
        .collection("moods")
        .where("uid", isEqualTo: user!.uid)
        .orderBy("time", descending: true)
        .snapshots();
  }

  // Delete Mood
  static Future<void> deleteMood(String id) async {
    await _firestore.collection("moods").doc(id).delete();
  }
  // Delete Journal
static Future<void> deleteJournal(String id) async {
  await _firestore.collection("journals").doc(id).delete();
}

  // Save Chat
  static Future<void> saveChat(
    String role,
    String text,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _firestore.collection("chats").add({
      "uid": user.uid,
      "role": role,
      "text": text,
      "time": FieldValue.serverTimestamp(),
    });
  }
  static Future<void> saveJournal(String text) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  await _firestore.collection("journals").add({
    "uid": user.uid,
    "text": text,
    "time": FieldValue.serverTimestamp(),
  });
}
// Get Journal History
static Stream<QuerySnapshot> getJournals() {
  final user = FirebaseAuth.instance.currentUser;

  return _firestore
      .collection("journals")
      .where("uid", isEqualTo: user!.uid)
      
      .snapshots();
}
//static Future<void> deleteJournal(String id) async {
  //await _firestore
    //  .collection("journals")
      //.doc(id)
      //.delete();
//}

  // Get Mood Counts for Analytics
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