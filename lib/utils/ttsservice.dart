import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class TtsService with ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool isSpeaking = false;

  TtsService() {
    _flutterTts.setStartHandler(() {
      isSpeaking = true;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      notifyListeners();
    });

    _flutterTts.setErrorHandler((message) {
      isSpeaking = false;
      notifyListeners();
    });
  }

  
  Future<void> initialize() async {
    await _flutterTts.setLanguage("en-US"); // Set language to English
    await _flutterTts.setSpeechRate(0.5); // Set speech rate (optional)
    await _flutterTts.setVolume(1.0); // Set volume to maximum (optional)
    await _flutterTts.setPitch(1.0); // Set pitch (optional)
  }

  Future<void> speak(String text) async {
    await _flutterTts.stop();  // Stop any ongoing speech
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
