import 'dart:developer';

import 'package:eby/utils/animationservice.dart';
import 'package:eby/utils/variablesprovider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eby/main.dart'; // For navigatorKey

class TtsService with ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool isSpeaking = false;
  String txt = "";

  TtsService() {
    _flutterTts.setStartHandler(() {
      log("Entering Start");
      bool studyMode = _getStudyMode();
      if (studyMode) {
        if (txt=="") {
          AnimationControllerService().triggerStudyListenToSpeak();
        } else {
          AnimationControllerService().triggerStudySpeak();
        }
      } else {
        if (txt=="") {
          AnimationControllerService().triggerListenToSpeak();
        } else {
          AnimationControllerService().triggerSpeak();
        }
      }
      isSpeaking = true;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() async {
      log("Entering Completion");
      bool studyMode = _getStudyMode();
      if (studyMode) {
        await Future.delayed(const Duration(seconds: 0));
        AnimationControllerService().triggerStudyIdle();
      } else {
        await Future.delayed(const Duration(seconds: 0));
        AnimationControllerService().triggerIdle();
      }
      isSpeaking = false;
      notifyListeners();
    });
    _flutterTts.setCancelHandler(()async {
      log("Entering Cancel");
      isSpeaking = false;
      bool studyMode = _getStudyMode();
      if (studyMode) {
        await Future.delayed(const Duration(seconds: 0));
        AnimationControllerService().triggerStudyIdle();
      } else {
        await Future.delayed(const Duration(seconds: 0));
        AnimationControllerService().triggerIdle();
      }
      notifyListeners();
    });

    _flutterTts.setErrorHandler((message)async {
      log("Entering Error");
      isSpeaking = false;
      bool studyMode = _getStudyMode();
      if (studyMode) {
        await Future.delayed(const Duration(seconds: 0));
        AnimationControllerService().triggerStudyIdle();
      } else {
        await Future.delayed(const Duration(seconds: 0));
        AnimationControllerService().triggerIdle();
      }
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
    log('speak');

    await _flutterTts.stop();
    await _flutterTts.speak(text);
    await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> stop() async {
    log('stop speak');
    bool studyMode = _getStudyMode();

    if (studyMode) {
      AnimationControllerService().triggerStudyIdle();
    } else {
      AnimationControllerService().triggerIdle();
    }
    await _flutterTts.stop();
  }

  bool _getStudyMode() {
    log('pulling mode');
    // Access the ModeProvider using the navigatorKey
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      log(Provider.of<ModeProvider>(currentContext, listen: false).studyMode.toString());
      return Provider.of<ModeProvider>(currentContext, listen: false).studyMode;
      
    }
    log("Context is null, returning false for studyMode by default.");
    return false;
  }
}
