import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  List<Map<String, String>> moodHistory = [];

  Future<void> saveMood(String emoji, String mood) async {
  final now = DateTime.now();

  try {
    await FirestoreService.saveMood(mood);

    setState(() {
      moodHistory.insert(0, {
        "emoji": emoji,
        "mood": mood,
        "date":
            "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$mood Mood Saved")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

  Widget moodButton(String emoji, String mood) {
    return GestureDetector(
      onTap: () async {
        await saveMood(emoji, mood);
      },
      child: Card(
        elevation: 4,
        child: SizedBox(
          width: 140,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 8),
              Text(
                mood,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                moodButton("😀", "Happy"),
                moodButton("😊", "Calm"),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                moodButton("😐", "Neutral"),
                moodButton("😢", "Sad"),
              ],
            ),

            const SizedBox(height: 20),

            Center(
              child: moodButton("😡", "Angry"),
            ),

            const SizedBox(height: 25),

            const Divider(),

            const Text(
              "Mood History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
  child: StreamBuilder(
    stream: FirestoreService.getMoods(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

if (snapshot.hasError) {
  return Center(
    child: Text("Error: ${snapshot.error}"),
  );
}

   if (snapshot.connectionState == ConnectionState.waiting) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

if (snapshot.hasError) {
  return Center(
    child: Text("Error: ${snapshot.error}"),
  );
}

if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  return const Center(
    child: Text(
      "No Mood Selected Yet",
      style: TextStyle(fontSize: 18),
    ),
  );
}

      final moods = snapshot.data!.docs;

      return ListView.builder(
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final data = moods[index].data() as Map<String, dynamic>;

          String emoji = "😐";

          switch (data["mood"]) {
            case "Happy":
              emoji = "😀";
              break;
            case "Calm":
              emoji = "😊";
              break;
            case "Neutral":
              emoji = "😐";
              break;
            case "Sad":
              emoji = "😢";
              break;
            case "Angry":
              emoji = "😡";
              break;
          }

          return Card(
            child: ListTile(
              leading: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
              title: Text(data["mood"] ?? ""),
              subtitle: Text(
                data["time"] == null
                    ? ""
                    : data["time"].toDate().toString(),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await FirestoreService.deleteMood(moods[index].id);
                },
              ),
            ),
          );
        },
      );
    },
  ),
)
          ],
        ),
      ),
    );
  }
}