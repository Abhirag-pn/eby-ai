import 'dart:developer';
import 'package:eby/utils/animationservice.dart';
import 'package:eby/utils/geminiservice.dart';
import 'package:eby/widgets/bouncingiconbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    GeminiService().initialize();
    super.initState();
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    speechService.isListening
                        ? speechService.wordsSpoken
                        : "Click on the microphone to start",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  BouncingIconButton(
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
                        String? response =
                            await GeminiService.instance.sendMessage(result);
                            if(response.isEmpty||response==""){
                              response="I didnt get you.try again!";
                            }else
                            {
                              await ttsService.speak(response);
                            }
                        
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
