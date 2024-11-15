import 'dart:async';
import 'dart:developer';

import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:permission_handler/permission_handler.dart';

class HotwordManager {
  PorcupineManager? _porcupineManager;
  final Function(int) onHotwordDetected;

  HotwordManager({required this.onHotwordDetected});

  Future<void> initialize() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      try {
        _porcupineManager = await PorcupineManager.fromKeywordPaths(
        "CYW3lQ75GhNwhezWbpQRB7hpdkeyVh4G4/hAz5MN+qieop07riXFUQ==",  // Replace with your actual access key
       ["assets/Hey-Eby_en_android_v3_0_0.ppn"],
      onHotwordDetected,
      );
        await _porcupineManager?.start();
        log("Porcupine is listening for the hotword...");
      } on PorcupineException catch (err) {
        log("ERROR OCCURRED: ${err.message}");
      }
    } else {
      log("Microphone permission denied");
    }
  }

  void dispose() {
    _porcupineManager?.stop();
    _porcupineManager?.delete();
  }
}
