import 'dart:developer';
import 'package:eby/utils/animationservice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ollama_dart/ollama_dart.dart';

class ModelService {
  // Flag to track initialization
  final client = OllamaClient(baseUrl: 'http://192.168.18.61:11434/api');
  // Private constructor
  ModelService._private();

  // Singleton instance
  static final instance = ModelService._private();

  // Factory constructor
  factory ModelService() => instance;


  Future<String> sendMessage(String text) async {
    AnimationControllerService().triggerThink();
    
    final request = GenerateCompletionRequest(
      model: 'ebychatbot', // Specify the model you want to use
      prompt: text,
      stream: false,
    );
  
    try {
     
        final generated = await client.generateCompletion(request: request);
        await  Future.delayed(const Duration(milliseconds: 1)); 
      AnimationControllerService().triggerSpeak();
      return generated.response!;
    } catch (e) {
      AnimationControllerService().triggerSpeak();
      log(e.toString());
      return "Error";
    }
  }
}

  // Method to return a custom response for certain phrases
 