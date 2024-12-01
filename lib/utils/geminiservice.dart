import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService with ChangeNotifier {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  Future<void> initialize() async {
    try {
      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: "AIzaSyCOK_MLrbAU7odgdJU_wvQo9RopeA3KnAw"
      );

      _chatSession = _model.startChat();
      notifyListeners();
    } catch (e) {
      log("Initialization Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<String> sendMessage(String userPrompt) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(userPrompt));
      return response.text!;
    } catch (e) {
      log("Message Error: ${e.toString()}");
      return "Error: Unable to process your request.";
    }
  }
}
