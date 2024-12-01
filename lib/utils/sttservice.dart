import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService with ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = '';

  String get wordsSpoken => _wordsSpoken;
  bool get isListening => _isListening;
  bool get speechEnabled => _speechEnabled;

  Future<void> initialize() async {
    _speechEnabled = await _speechToText.initialize();
    notifyListeners();
  }

  Future<void> startListening() async {
    if (_speechEnabled && !_isListening) {
      _isListening = true;
  
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor:const Duration(seconds: 60), // Stop after 60 seconds
        pauseFor:const  Duration(seconds: 3), // Pause for 3 seconds before auto-stop
      );
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.stop();
      notifyListeners();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _wordsSpoken = result.recognizedWords;
    notifyListeners();
  }

  void clearLastWords() {
    _wordsSpoken = '';
    notifyListeners();
  }
}
