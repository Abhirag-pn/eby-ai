import 'dart:developer';

import 'package:eby/utils/animationservice.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class GemmaService {

late final gemmainstance=FlutterGemmaPlugin.instance;
  // Private constructor
  GemmaService._private();

  // Singleton instance
  static final instance = GemmaService._private();

  // Factory constructor
  factory GemmaService() => instance;





  Future<String> sendMessage(String userPrompt) async {
    try {
      log("sending to gemmA");
      // Check if the user's prompt contains any custom phrases
      String response = await _handleCustomPhrases(userPrompt);
      if (response.isNotEmpty) {
        return response; // Return custom response without sending to Gemini
      }

      // If not a custom phrase, forward the request to Gemini
      AnimationControllerService().triggerThink();
      
String? gemmaresponse = await gemmainstance.getResponse(prompt:userPrompt);
     
      log("Response from Gemma: ${gemmaresponse!}");

      // Clean the response before returning
     

      return gemmaresponse;
    } catch (e) {
      AnimationControllerService().triggerIdle();
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

}
