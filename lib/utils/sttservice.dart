import 'dart:async';
import 'dart:developer';

import 'package:eby/utils/geminiservice.dart';
import 'package:eby/utils/ttsservice.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService with ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = '';
  Completer<String>? _listeningCompleter;

  String get wordsSpoken => _wordsSpoken;
  bool get isListening => _isListening;
  bool get speechEnabled => _speechEnabled;

  Future<void> initialize() async {
    _speechEnabled = await _speechToText.initialize();
    notifyListeners();
  }

  Future<String> startListening() async {
    if (_listeningCompleter?.isCompleted == false) {
      // Cancel the previous completer if it hasn't completed
      _listeningCompleter = null;
    }

    if (_speechEnabled && !_isListening) {
      _isListening = true;
      clearLastWords();
      _listeningCompleter = Completer<String>();

      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 60), // Stop after 60 seconds
        pauseFor:
            const Duration(seconds: 3), // Pause for 3 seconds before auto-stop
      );

      notifyListeners();

      // Return the future that will complete when the final result is received
      return _listeningCompleter!.future;
    } else {
      throw Exception("Speech recognition not enabled or already listening.");
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.stop();

      if (_listeningCompleter?.isCompleted == false) {
        _listeningCompleter?.complete(_wordsSpoken);
      }

      notifyListeners();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    _wordsSpoken = result.recognizedWords;
    if (result.finalResult) {
      if (_listeningCompleter?.isCompleted == false) {
        _listeningCompleter?.complete(_wordsSpoken);
      }

      // Process with Gemini and TTS
      try {
        final gemini = GeminiService();
        final tts = TtsService();
        final res = await gemini.sendMessage(result.recognizedWords);
        log(result.recognizedWords);
        await tts.speak(res);
      } on Exception catch (e, s) {
        Logger().e(e);
        Logger().e(s);
      }
    }
    notifyListeners();
  }

  void clearLastWords() {
    _wordsSpoken = '';
    notifyListeners();
  }
}
