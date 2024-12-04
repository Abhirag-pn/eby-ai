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
 
  @override
  void initState() {
    GeminiService().initialize();
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
            Align(
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
                    if(result=="")
                    {  
                       await ttsService.speak("I didnt get you,try again!");
                       
              
                    }else{
                    String? response =
                        await GeminiService.instance.sendMessage(result!);
                        if(response.isEmpty||response==""){
                          response="I didnt get you,try again!";
                        }else
                        {
                          await ttsService.speak(response);
                        }
                    
                  }}
                },
              ),
            ),
           
            Padding(
              
              padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/7),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                      speechService.isListening
                          ? speechService.wordsSpoken
                          :speechService.speechEnabled?"Click on the microphone to start":"Unavailable",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black38,fontFamily: 'Bowl'),
                    ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 20.0,right:10),
              child: Align(
                alignment: Alignment.topRight,
              child:SpeedDial(
                backgroundColor: Colors.transparent,
              
                child:  BouncingIconButton(button: "assets/images/settingsicon.png", action: (){}),
                overlayColor: Colors.black26,
                direction: SpeedDialDirection.down,
                children: [
                  SpeedDialChild(
                    backgroundColor: Colors.transparent,
                     child: BouncingIconButton(button: "assets/images/exiticon.png", action: (){})
                  )
                ],
              )
              ),
              
            ),
          ],
        ),
      ),
    );
  }
}
