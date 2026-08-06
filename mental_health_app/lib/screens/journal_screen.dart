import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController journalController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Journal"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: journalController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: "Write about your day...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (journalController.text.trim().isEmpty) return;

                  await FirestoreService.saveJournal(
                    journalController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Journal Saved Successfully"),
                    ),
                  );

                  journalController.clear();
                },
                child: const Text("Save Journal"),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Journal History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

Expanded(
  child: StreamBuilder(
    stream: FirestoreService.getJournals(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text(
            "No Journal Yet",
            style: TextStyle(fontSize: 18),
          ),
        );
      }

      final journals = snapshot.data!.docs;

      return ListView.builder(
        itemCount: journals.length,
        itemBuilder: (context, index) {
          final data =
              journals[index].data() as Map<String, dynamic>;

          return Card(
            child: ListTile(
              title: Text(data["text"] ?? ""),
              subtitle: Text(
                data["time"] == null
                    ? ""
                    : data["time"].toDate().toString(),
              ),
            ),
          );
        },
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