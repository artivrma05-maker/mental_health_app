import 'package:flutter/material.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  List<Map<String, String>> moodHistory = [];

  void saveMood(String emoji, String mood) {
    final now = DateTime.now();

    setState(() {
      moodHistory.insert(0, {
        "emoji": emoji,
        "mood": mood,
        "date":
            "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$mood mood saved successfully"),
      ),
    );
  }

  Widget moodButton(String emoji, String mood) {
    return GestureDetector(
      onTap: () => saveMood(emoji, mood),
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
              child: moodHistory.isEmpty
                  ? const Center(
                      child: Text(
                        "No Mood Selected Yet",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: moodHistory.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Text(
                              moodHistory[index]["emoji"]!,
                              style: const TextStyle(fontSize: 28),
                            ),
                            title: Text(moodHistory[index]["mood"]!),
                            subtitle: Text(moodHistory[index]["date"]!),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  moodHistory.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}