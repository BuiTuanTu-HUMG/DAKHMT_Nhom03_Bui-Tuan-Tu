import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotService {
  static final String _geminiKey =  dotenv.env['Gemini_API_Key'] ?? '';
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent';

  static Future<String?> getChatResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse("$_geminiUrl?key=$_geminiKey"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text']?.toString();
      } else {
        return "Gemini API lỗi: ${response.statusCode}\n${response.body}";
      }
    } catch (e) {
      return "Lỗi: ${e.toString()}";
    }
  }
}
