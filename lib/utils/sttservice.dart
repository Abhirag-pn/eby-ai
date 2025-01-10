import 'dart:async';
import 'dart:developer';
import 'package:eby/utils/animationservice.dart';// Import ModeProvider
import 'package:eby/utils/variablesprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService with ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = '';
  bool _studyMode = false; // Track the study mode state locally

  Completer<String>? _listeningCompleter;
  Timer? _listenTimeoutTimer;

  String get wordsSpoken => _wordsSpoken;
  bool get isListening => _isListening;
  bool get speechEnabled => _speechEnabled;

  // Call this method to update study mode state
  void updateStudyMode(bool studyMode) {
    _studyMode = studyMode;
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onError: _onSpeechError,
        onStatus: _onSpeechStatus,
      );
      log("Speech recognition initialized successfully.");
    } catch (e) {
      log("Failed to initialize speech recognition: $e");
    }
    notifyListeners();
  }

  Future<String?> startListening(BuildContext context) async {
    // Get study mode state from ModeProvider and update locally
    final studyMode = Provider.of<ModeProvider>(context, listen: false).studyMode;
    updateStudyMode(studyMode);

    // Trigger appropriate animation
    if (_studyMode) {
      AnimationControllerService().triggerStudyListen();
    } else {
      AnimationControllerService().triggerListen();
    }

    if (_listeningCompleter?.isCompleted == false) {
      _listeningCompleter = null; // Cancel any ongoing listening session
    }

    if (_speechEnabled && !_isListening) {
      _isListening = true;
      clearLastWords();
      _listeningCompleter = Completer<String>();

      try {
        await _speechToText.listen(
          listenOptions: SpeechListenOptions(
            listenMode: ListenMode.dictation,
          ),
          onResult: (result) {
            _onSpeechResult(result, _studyMode);
          },
          listenFor: const Duration(seconds: 60),
          pauseFor: const Duration(seconds: 3),
        );

        _listenTimeoutTimer = Timer(const Duration(seconds: 60), () async {
          if (_isListening) {
            if (_studyMode) {
              AnimationControllerService().triggerStudyIdle();
            } else {
              AnimationControllerService().triggerIdle();
            }
            await stopListening();
          }
        });

        log("Started listening for speech.");
        notifyListeners();
        return _listeningCompleter!.future;
      } catch (e) {
        log("Error starting speech recognition: $e");
        throw Exception("Failed to start speech recognition.");
      }
    } else if (_isListening) {
      log("Already listening, stopping current session.");
      await stopListening();
      return null;
    } else {
      throw Exception("Speech recognition not enabled.");
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;

      if (_studyMode) {
        AnimationControllerService().triggerStudyIdle();
      } else {
        AnimationControllerService().triggerIdle();
      }

      await _speechToText.stop();
      _listenTimeoutTimer?.cancel(); // Cancel the timeout timer

      if (_wordsSpoken.isEmpty && _listeningCompleter?.isCompleted == false) {
        _listeningCompleter?.complete("");
        log("No words recognized before stopping.");
      } else if (_listeningCompleter?.isCompleted == false) {
        _listeningCompleter?.complete(_wordsSpoken);
      }

      notifyListeners(); // Update the UI when stopped
      log("Stopped listening for speech.");
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result, bool? study) async {
    _wordsSpoken = result.recognizedWords;
    if (result.finalResult) {
      if (_listeningCompleter?.isCompleted == false) {
        if (_wordsSpoken.isEmpty) {
          _listeningCompleter?.complete("");
          log("Final result received, but no words were recognized.");
        } else {
          _listeningCompleter?.complete(_wordsSpoken);
          log("Final result received: $_wordsSpoken");
        }
        _isListening = false;
        if (_studyMode) {
          AnimationControllerService().triggerStudyIdle();
        } else {
          AnimationControllerService().triggerIdle();
        }
        notifyListeners();
      }
    }
    notifyListeners(); // Update UI with recognized words
  }

  void _onSpeechError(SpeechRecognitionError error) {
    log("Speech recognition error: ${error.errorMsg} (Permanent: ${error.permanent})");

    if (error.errorMsg == "error_speech_timeout" || error.errorMsg == "No words recognized.") {
      log("Speech recognition stopped: ${error.errorMsg}");
      _wordsSpoken = "No words recognized.";
      _isListening = false;

      if (_studyMode) {
        AnimationControllerService().triggerStudyIdle();
      } else {
        AnimationControllerService().triggerIdle();
      }
      _listeningCompleter?.complete(""); // Return the default message
    } else {
      _isListening = false;
      if (_studyMode) {
        AnimationControllerService().triggerStudyIdle();
      } else {
        AnimationControllerService().triggerIdle();
      }
      _listeningCompleter?.complete("");
    }

    notifyListeners(); // Ensure UI updates
  }

  void _onSpeechStatus(String status) {
    log("Speech recognition status: $status");
    if (status == "notListening") {
      _isListening = false;
      if (_studyMode) {
        AnimationControllerService().triggerStudyIdle();
      } else {
        AnimationControllerService().triggerIdle();
      }
      notifyListeners();
    }
  }

  void clearLastWords() {
    _wordsSpoken = '';
    notifyListeners(); // Clear words and update UI
  }

  @override
  void dispose() {
    _listenTimeoutTimer?.cancel(); // Cancel the timer when disposed
    super.dispose();
  }
}
