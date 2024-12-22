import 'dart:async';
import 'dart:developer';
import 'package:eby/utils/animationservice.dart';
import 'package:eby/utils/geminiservice.dart';
import 'package:eby/widgets/bouncingiconbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;

import '../utils/sttservice.dart';
import '../utils/ttsservice.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  bool _isLoading = true;
  bool studymode=false;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    GeminiService().initialize();
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    AnimationControllerService().dispose();
    TtsService().stop();
    SpeechToTextService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speechService = Provider.of<SpeechToTextService>(context);
    final ttsService = Provider.of<TtsService>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            rive.RiveAnimation.asset(
              'assets/rive/eby.riv',
              onInit: (artboard) {
                AnimationControllerService().initializeController(artboard);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BouncingIconButton(
                  button: speechService.isListening
                      ? 'assets/images/listening.png'
                      : 'assets/images/mic.png',
                  action: () async {
                    if (speechService.isListening) {
                      await speechService.stopListening();
                      await ttsService.stop();
                    } else {
                      ttsService.stop();
                      final result = await speechService.startListening();
                      if (result == "") {
                        await ttsService.speak("I didnt get you,try again!");
                      } else {
                        String? response =
                            await GeminiService.instance.sendMessage(result!);
                        if (response.isEmpty || response == "") {
                          response = "I didnt get you,try again!";
                        } else {
                          await ttsService.speak(response);
                        }
                      }
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 7),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  speechService.isListening
                      ? speechService.wordsSpoken
                      : speechService.speechEnabled
                          ? "Click on the microphone to start"
                          : "Unavailable",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black38, fontFamily: 'Bowl'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: SpeedDial(
                    spacing: 10,
                    spaceBetweenChildren: 8,
                    elevation: 2,
                    activeBackgroundColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    shape: const CircleBorder(),
                    openCloseDial: isDialOpen,
                    overlayColor: Colors.transparent,
                    direction: SpeedDialDirection.down,
                    buttonSize: const Size(70, 70),
                    childrenButtonSize: const Size(70, 70),
                    
                    children: [
                      SpeedDialChild(
                        elevation: 2,
                         shape: const CircleBorder(),
                        backgroundColor: Colors.transparent,
                        child: BouncingIconButton(
                            button: "assets/images/graph.png",
                            action: () {
                               isDialOpen.value = !isDialOpen.value;
                            }),
                      ),
                      SpeedDialChild(
                         shape: const CircleBorder(),
                        elevation: 2,
                        backgroundColor: Colors.transparent,
                        child: BouncingIconButton(
                            button: "assets/images/exiticon.png",
                            action: () {
                               isDialOpen.value = !isDialOpen.value;
                            }),
                      ),
                    ],
                    renderOverlay: false,
                    activeChild: BouncingIconButton(
                        button: "assets/images/settingsicon.png",
                        action: () {
                          isDialOpen.value = !isDialOpen.value;
                        }),
                    child: BouncingIconButton(
                        button: "assets/images/settingsicon.png",
                        action: () {
                          isDialOpen.value = !isDialOpen.value;
                        }),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: BouncingIconButton(
                    button: 'assets/images/mode2.png', action: () {}),
              ),
            ),
            if (_isLoading)
              Container(
                decoration: const BoxDecoration(color: Colors.black),
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Loading...",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.white, fontFamily: 'Bowl'),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
