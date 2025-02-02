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
        model: 'gemini-1.5-flash',
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
      // Check if the user's prompt contains any custom phrases
      String response = await _handleCustomPhrases(userPrompt);
      if (response.isNotEmpty) {
        return response; // Return custom response without sending to Gemini
      }

      // If not a custom phrase, forward the request to Gemini
      AnimationControllerService().triggerStudyThink();
      final geminiResponse = await _chatSession.sendMessage(Content.text(userPrompt,),);
      log("Response from Gemini: ${geminiResponse.text!}");

      // Clean the response before returning
      String cleanedResponse = cleanResponse(geminiResponse.text!);

      return cleanedResponse;
    } catch (e) {
      AnimationControllerService().triggerStudyIdle();
      log("Message Error: ${e.toString()}");
      return "Error: Unable to process your request.";
    }
  }

  // Method to handle custom phrases
  Future<String> _handleCustomPhrases(String userPrompt) async {
    // List of custom phrases that should trigger a special response
    List<String> triggerPhrases = [
      "who are you",
      "what's your name",
      "do I know you",
      "tell me about you",
      "who is this",
      "are you there",
      "what's your purpose",
      "what is your name",
      "your name"
    ];

    // Check if the user's prompt contains any of the trigger phrases
    for (var phrase in triggerPhrases) {
      if (userPrompt.toLowerCase().contains(phrase)) {
        return _getCustomResponse(phrase); // Return the appropriate custom response
      }
    }
    return ''; // Return an empty string if no custom phrase is matched
  }

  // Method to return a custom response for certain phrases
  String _getCustomResponse(String userPrompt) {
    if (userPrompt.contains("who are you") || 
        userPrompt.contains("what's your name") ||
        userPrompt.contains("tell me about you")) {
      return "I am EBY, your personal assistant!";
    }
    // You can add more custom responses for other phrases here
    return "I am EBY,I'm here to assist you with any questions.";
  }

  // Method to clean response from Gemini
  String cleanResponse(String response) {
    // Remove double asterisks "**"
    response = response.replaceAll('**', '');

    // Remove triple backquotes (```), which could be part of a block
    response = response.replaceAll(RegExp(r'```.*?```', dotAll: true), '');

AnimationControllerService().triggerStudySpeak();
    return response;
    
  }


  Future<List<Map<String, dynamic>>> generateQuizQuestions(String topic) async {
  final prompt = """
  Create a quiz on the topic "$topic". Provide 5 questions with four options each (A, B, C, D) and indicate the correct answer for each.
  Format:
  Q1: <question>
  Options:
  A) <option A>
  B) <option B>
  C) <option C>
  D) <option D>
  Answer: <option>) <correct answer>
  Q2: ...
  """;

  final response = await sendMessage(prompt);
  log("initial: $response");
  final questionRegex = RegExp(
    r"Q\d+: (.*)\nOptions:\nA\) (.*)\nB\) (.*)\nC\) (.*)\nD\) (.*)\nAnswer: (.*)",
    multiLine: true,
  );

  final matches = questionRegex.allMatches(response);
  if (matches.isEmpty) {
    throw Exception("Failed to parse quiz questions from the response.");
  }

  return matches.map((match) {
    return {
      "question": match.group(1)?.trim(),
      "options": [
        match.group(2)?.trim(),
        match.group(3)?.trim(),
        match.group(4)?.trim(),
        match.group(5)?.trim(),
      ],
      "answer": match.group(6)?.trim(),
    };
  }).toList();
}

}
