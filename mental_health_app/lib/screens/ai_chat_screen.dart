import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../services/firestore_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode messageFocus = FocusNode();

  List<Map<String, String>> messages = [];

  bool isLoading = false;

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    String userMessage = messageController.text.trim();

    setState(() {
      messages.add({
        "role": "user",
        "text": userMessage,
      });

      isLoading = true;
    });
    await FirestoreService.saveChat("user", userMessage);

    messageController.clear();

    String aiReply =
        await GeminiService.askGemini(userMessage);

    setState(() {
      messages.add({
        "role": "ai",
        "text": aiReply,
      });

      isLoading = false;
    });
    await FirestoreService.saveChat("ai", aiReply);
    messageFocus.requestFocus();
    
    Future.delayed(const Duration(milliseconds: 200), () {
  scrollController.animateTo(
    scrollController.position.maxScrollExtent,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
});
  }

  Widget buildMessage(
      String role,
      String text,
      ) {
    bool isUser = role == "user";

    return Align(
      alignment:
      isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin:
        const EdgeInsets.symmetric(
          vertical: 6,
        ),
        padding:
        const EdgeInsets.all(12),
        constraints:
        const BoxConstraints(
          maxWidth: 280,
        ),
        decoration: BoxDecoration(
          color:
          isUser
              ? Colors.teal
              : Colors.grey.shade300,
          borderRadius:
          BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
            isUser
                ? Colors.white
                : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      "Ask anything about your mental wellness 🤖",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                  controller: scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return buildMessage(
                        messages[index]["role"]!,
                        messages[index]["text"]!,
                      );
                    },
                  ),
          ),

         if (isLoading)
  const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 15,
            child: Icon(Icons.smart_toy, size: 18),
          ),
          SizedBox(width: 10),
          Text(
            "AI is typing...",
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    ),
  ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    focusNode: messageFocus,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.teal,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}