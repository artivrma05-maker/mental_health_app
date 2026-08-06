import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, int> moodCounts = {};

  @override
  void initState() {
    super.initState();
    loadMoodCounts();
  }

  Future<void> loadMoodCounts() async {
    final data = await FirestoreService.getMoodCounts();

    setState(() {
      moodCounts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (moodCounts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mood Analytics"),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Analytics"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Mood Summary",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Card(
                child: ListTile(
                  leading: const Text("😀", style: TextStyle(fontSize: 30)),
                  title: const Text("Happy"),
                  trailing: Text("${moodCounts["Happy"]}"),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Text("😊", style: TextStyle(fontSize: 30)),
                  title: const Text("Calm"),
                  trailing: Text("${moodCounts["Calm"]}"),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Text("😐", style: TextStyle(fontSize: 30)),
                  title: const Text("Neutral"),
                  trailing: Text("${moodCounts["Neutral"]}"),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Text("😢", style: TextStyle(fontSize: 30)),
                  title: const Text("Sad"),
                  trailing: Text("${moodCounts["Sad"]}"),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Text("😡", style: TextStyle(fontSize: 30)),
                  title: const Text("Angry"),
                  trailing: Text("${moodCounts["Angry"]}"),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: moodCounts["Happy"]!.toDouble(),
                        title: "😀",
                        radius: 70,
                      ),
                      PieChartSectionData(
                        value: moodCounts["Calm"]!.toDouble(),
                        title: "😊",
                        radius: 70,
                      ),
                      PieChartSectionData(
                        value: moodCounts["Neutral"]!.toDouble(),
                        title: "😐",
                        radius: 70,
                      ),
                      PieChartSectionData(
                        value: moodCounts["Sad"]!.toDouble(),
                        title: "😢",
                        radius: 70,
                      ),
                      PieChartSectionData(
                        value: moodCounts["Angry"]!.toDouble(),
                        title: "😡",
                        radius: 70,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}