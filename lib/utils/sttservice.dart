import 'dart:async';
import 'dart:developer';

import 'package:eby/utils/animationservice.dart';
import 'package:eby/utils/geminiservice.dart';
import 'package:eby/utils/ttsservice.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService with ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = '';
  Completer<String>? _listeningCompleter;
  Timer? _listenTimeoutTimer;

  String get wordsSpoken => _wordsSpoken;
  bool get isListening => _isListening;
  bool get speechEnabled => _speechEnabled;

  Future<void> initialize() async {
    _speechEnabled = await _speechToText.initialize();
    notifyListeners();
  }

  Future<String> startListening() async {
    AnimationControllerService().triggerListen();
    if (_listeningCompleter?.isCompleted == false) {
      _listeningCompleter =
          null; // Cancel the previous completer if it hasn't completed
    }

    if (_speechEnabled && !_isListening) {
      _isListening = true;
      clearLastWords();
      _listeningCompleter = Completer<String>();

      await _speechToText.listen(
        listenOptions: SpeechListenOptions(listenMode: ListenMode.dictation),
        onResult: _onSpeechResult,
        listenFor: const Duration(
            seconds: 60), // Listen for 60 seconds (can be adjusted)
        pauseFor:
            const Duration(seconds: 3), // Pause for 3 seconds before auto-stop
      );

      _listenTimeoutTimer = Timer(const Duration(seconds: 60), () async {
        if (_isListening) {
          AnimationControllerService().triggerIdle();
          await stopListening();
        }
      });

      notifyListeners();
      return _listeningCompleter!.future;
    } else {
      AnimationControllerService().triggerListen();
      throw Exception("Speech recognition not enabled or already listening.");
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      AnimationControllerService().triggerIdle();
      await _speechToText.stop();

      _listenTimeoutTimer?.cancel(); // Cancel the timeout timer

      if (_listeningCompleter?.isCompleted == false) {
        _listeningCompleter?.complete(_wordsSpoken);
      }

      notifyListeners(); // Make sure to notify listeners to update the UI when stopped
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    _wordsSpoken = result.recognizedWords;
    if (result.finalResult) {
      if (_listeningCompleter?.isCompleted == false) {
        _listeningCompleter?.complete(_wordsSpoken);
        _isListening = false; // Update the listening state when result is final
        notifyListeners();
      }
    }
    notifyListeners(); // Ensure the UI updates with the recognized words
  }

  void clearLastWords() {
    _wordsSpoken = '';
    notifyListeners(); // Clear words and update UI
  }

  @override
  void dispose() {
    _listenTimeoutTimer
        ?.cancel(); // Make sure to cancel the timer when disposed
    super.dispose();
  }
}
