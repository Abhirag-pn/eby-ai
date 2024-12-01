import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
   rive.SMITrigger? startlisten,startthink,startspeak;

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

    art.addController(ctrl);
    setState(() {});

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Image.asset('assets/images/bg.png'),
            rive.RiveAnimation.asset('assets/rive/eby.riv',onInit: _onInit,)

          ],
        ),
      ),
    );
  }
}