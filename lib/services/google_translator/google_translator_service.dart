import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:leafora/components/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';

class GoogleTranslatorService {
  String translatedText = "";
  String apiKey = dotenv.env['CLOUD_API_KEY']!;

  Future<String> translate(String text, String targetLanguage) async {
    try {
      // Split the text into markdown and non-markdown parts
      List<String> parts = [];
      bool isMarkdown = false;
      String currentPart = '';

      // Process text character by character
      for (int i = 0; i < text.length; i++) {
        if (text[i] == '#' || text[i] == '*' || text[i] == '_' || text[i] == '`' || text[i] == '[' || text[i] == ']') {
          if (currentPart.isNotEmpty) {
            parts.add(currentPart);
            currentPart = '';
          }
          parts.add(text[i]);
          isMarkdown = !isMarkdown;
        } else {
          currentPart += text[i];
        }
      }
      if (currentPart.isNotEmpty) {
        parts.add(currentPart);
      }

      // Translate only non-markdown parts
      List<String> translatedParts = [];
      for (String part in parts) {
        if (part.contains(RegExp(r'[#*_`\[\]]'))) {
          // Keep markdown symbols as is
          translatedParts.add(part);
        } else if (part.trim().isNotEmpty) {
          // Translate non-empty, non-markdown parts
          final Uri uri = Uri.parse('https://translation.googleapis.com/language/translate/v2').replace(
            queryParameters: {
              'key': apiKey,
            },
          );

          final response = await http.post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'q': part,
              'target': targetLanguage,
            }),
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = json.decode(response.body);
            String translatedPart = responseData['data']['translations'][0]['translatedText'];
            translatedParts.add(translatedPart);
          } else {
            print('Translation failed with status code: ${response.statusCode}');
            print('Error response: ${response.body}');
            throw Exception('Failed to translate the text');
          }
        } else {
          // Keep empty parts (spaces, newlines) as is
          translatedParts.add(part);
        }
      }

      // Combine all parts back together
      translatedText = translatedParts.join('');
      return translatedText;

    } catch (e) {
      print('Translation error: $e');
      CustomToast.show(
        "Failed to translate the text.",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception('Failed to translate the text: $e');
    }
  }
}