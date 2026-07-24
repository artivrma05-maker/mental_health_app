import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental Health"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Welcome 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "How are you feeling today?",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Mood Tracker"),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              child: const Text("AI Chat"),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Journal"),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Meditation"),
            ),
          ],
        ),
      ),
    );
  }
}