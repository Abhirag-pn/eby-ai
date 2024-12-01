import 'dart:developer';

import 'package:eby/utils/geminiservice.dart';
import 'package:flutter/foundation.dart';
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
   rive.SMITrigger? startlisten,startthink,startspeak,startidle;

   void onRiveEvent(rive.RiveEvent event) {
    print(event);
  }


  void _onInit(rive.Artboard art)
  {
    var ctrl=rive.StateMachineController.fromArtboard(art,'eby_state_machine') as rive.StateMachineController;

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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Image.asset('assets/images/bg.png',fit: BoxFit.fill,),
            rive.RiveAnimation.asset('assets/rive/eby.riv',onInit: _onInit,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: ()
                 async {
                    
                     if (speechService.isListening) {
                  await speechService.stopListening();
                  
                } else {
                  startlisten!.fire();
                  final result =await speechService.startListening();
                  log("stopped listening");
                  startthink!.fire();
                 final res= await GeminiService.instance.sendMessage(result);
                 startspeak!.fire();
                 await ttsService.speak(res);
                 startidle!.fire();

                  log(result);
               
                }
                  }, child: Text("Listen")),
                  ElevatedButton(onPressed: (){  startidle!.fire();}, child: Text("data"))
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}