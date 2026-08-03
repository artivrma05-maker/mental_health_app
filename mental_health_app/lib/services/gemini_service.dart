import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_key.dart';

class GeminiService {
  static Future<String> askGemini(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer ${openRouterApiKey}",
          "Content-Type": "application/json",
          "HTTP-Referer": "https://localhost",
          "X-Title": "Mental Health App",
        },
        body: jsonEncode({
          "model": "openai/gpt-4.1-mini",
          "max_tokens": 500,
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a kind and supportive mental health assistant. Give helpful, empathetic, and safe responses."
            },
            {
              "role": "user",
              "content": prompt
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "API Error: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}