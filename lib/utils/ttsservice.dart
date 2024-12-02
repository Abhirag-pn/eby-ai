import 'package:eby/utils/animationservice.dart';
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
      AnimationControllerService().triggerIdle();
      notifyListeners();
    });

    _flutterTts.setErrorHandler((message) {
      isSpeaking = false;
      AnimationControllerService().triggerIdle();
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
    await _flutterTts.stop();
    AnimationControllerService().triggerSpeak(); // Stop any ongoing speech
    await _flutterTts.speak(text);
    await _flutterTts.awaitSpeakCompletion(true);
    
  }

  Future<void> stop() async {
    AnimationControllerService().triggerIdle();
    await _flutterTts.stop();
  }
}
