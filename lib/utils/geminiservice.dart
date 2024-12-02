import 'dart:developer';
import 'package:eby/utils/animationservice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  bool _isInitialized = false; // Flag to track initialization

  // Private constructor
  GeminiService._private();

  // Singleton instance
  static final instance = GeminiService._private();

  // Factory constructor
  factory GeminiService() => instance;

  Future<void> initialize() async {
    if (_isInitialized) {
      log("GeminiService is already initialized.");
      return;
    }

    try {
      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: dotenv.get('API_KEY'),
      );

      _chatSession = _model.startChat();
      _isInitialized = true; // Mark as initialized
      log("GeminiService initialized successfully.");
    } catch (e) {
      log("Initialization Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<String> sendMessage(String userPrompt) async {
    try {
      AnimationControllerService().triggerThink();
      final response = await _chatSession.sendMessage(Content.text(userPrompt));
      log("Response from Gemini: ${response.text!}");
      return response.text!;
    } catch (e) {
      AnimationControllerService().triggerIdle();
      log("Message Error: ${e.toString()}");
      return "Error: Unable to process your request.";
    }
  }
}
