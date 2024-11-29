import 'dart:developer';

import 'package:eby/utils/audiohelper.dart';
import 'package:eby/utils/hotwordmanager.dart';
import 'package:eby/utils/sttservice.dart';
import 'package:eby/utils/ttsservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final ttsService;
  bool isInitialised = false;
  // bool isActive = false;
  // late HotwordManager _hotwordManager;

  // void _wakeWordCallback(int keywordIndex) {
  //   log("Hotword detected on main screen! Index: $keywordIndex");
  //   setState(() {
  //     isActive = !isActive;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // _hotwordManager = HotwordManager(onHotwordDetected: _wakeWordCallback);
    // _hotwordManager.initialize();
  }

  // @override
  // void dispose() {
  //   _hotwordManager.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final speechService = Provider.of<SpeechToTextService>(context);
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
               const Text('Recognized words:', style: TextStyle(fontSize: 20.0)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  speechService.isListening
                      ? speechService.lastWords
                      : speechService.speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                  style: const TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    log("Listen licked");
                     if (speechService.isListening) {
                    speechService.stopListening();
                  } else {
                    speechService.startListening();
                  }
                  },
                  child: Text("Listen")),
                   ElevatedButton(
                  onPressed: () {
                    log("clicked");
                    Provider.of<TtsService>(context, listen: false)
                        .speak(speechService.lastWords);
                  },
                  child: Text("Speak")),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      AudioHelper.instance.resumeMusic();
                      await FirebaseAuth.instance.signOut();
                    } catch (e) {
                      Logger().d(e.toString());
                    }
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        ));
  }
}
