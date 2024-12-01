import 'dart:developer';
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
    super.initState();
    GeminiService().initialize();
  }

  late rive.StateMachineController ctrl;
  rive.SMITrigger? startlisten, startthink, startspeak, startidle;

  void onRiveEvent(rive.RiveEvent event) {
    print(event);
  }

  void _onInit(rive.Artboard art) {
    ctrl = rive.StateMachineController.fromArtboard(art, 'eby_state_machine')
        as rive.StateMachineController;

    ctrl.addEventListener(onRiveEvent);
    startlisten = ctrl.getTriggerInput('start listening');
    startthink = ctrl.getTriggerInput('start think');
    startspeak = ctrl.getTriggerInput('start speak');
    startidle = ctrl.getTriggerInput('go to idle normal');

    art.addController(ctrl);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final speechService = Provider.of<SpeechToTextService>(context);
    final ttsService = Provider.of<TtsService>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg.png',
                ),
                fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            rive.RiveAnimation.asset('assets/rive/eby.riv', onInit: _onInit),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(speechService.isListening?speechService.wordsSpoken:"Click on the microphone to start " ,style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),),
                    SizedBox(height: 30,),
                    BouncingIconButton(
                        button: speechService.isListening
                            ? 'assets/images/listening.png'
                            : 'assets/images/mic.png',
                        action: () async {
                          setState(() {});

                          if (speechService.isListening) {
                            await speechService.stopListening();
                             await ttsService.stop();
                            startidle!.fire();
                          
                          } else {
                            ttsService.stop();
                            startlisten!.fire();
                            final result = await speechService.startListening();
                            log("stopped listening");
                            startthink!.fire();
                            final res = await GeminiService.instance
                                .sendMessage(result);
                            startspeak!.fire();
                            await ttsService.speak(res);
                            startidle!.fire(); // Adjust delay as needed
                          }
                        }),
                  ],
                ),
              ),
             
            ),
             Padding(
               padding: const EdgeInsets.only(top: 20.0,right: 10),
               child: Align(
                alignment: Alignment.topRight,
                child: BouncingIconButton(button: "assets/images/exiticon.png", action: (){
                   ttsService.dispose();
                  FirebaseAuth.instance.signOut();
                }),
               ),
             )
          ],
        ),
      ),
    );
  }
}
