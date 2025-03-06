
  import 'dart:developer';
import 'package:eby/utils/animationservice.dart';
import 'package:ollama_dart/ollama_dart.dart';

class ModelService {
  final client = OllamaClient(baseUrl: 'http://192.168.43.202:11434/api');

  ModelService._private();
  static final instance = ModelService._private();
  factory ModelService() => instance;

  Future<String> sendMessage(String text) async {
    await Future.delayed(Duration(milliseconds: 200)); 
    AnimationControllerService().triggerThink();
    
    await Future.delayed(Duration(milliseconds: 200)); // Ensure UI updates

    final request = GenerateCompletionRequest(
      model: 'ebychatbot', 
      prompt: text,
      stream: false,
    );

    try {
      log("Sending request to Ollama...");
      final generated = await client.generateCompletion(request: request);
      log("Response from Ollama: ${generated.response}");

      await Future.delayed(Duration(milliseconds: 100)); 
      
      AnimationControllerService().triggerSpeak();
      String cleanedResponse = cleanText(generated.response!);
      return cleanedResponse;
    } catch (e) {
      AnimationControllerService().triggerIdle(); // Reset to idle on error
      log("Error in ModelService: $e");
      return "Error"+e.toString();
    }
  }

  String cleanText(String input) {
    return input.replaceAll(RegExp(r'[*•]+'), '').trim();
  }
}
