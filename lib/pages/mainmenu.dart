

import 'package:eby/utils/authservice.dart';
import 'package:eby/widgets/bouncingiconbutton.dart';
import 'package:eby/widgets/bouncingtextbutton.dart';
import 'package:flutter/material.dart';

import '../utils/audiohelper.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with WidgetsBindingObserver {




@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state==AppLifecycleState.paused)
    {
      AudioHelper.instance.pauseBackgroundMusic();
    }
    if(state==AppLifecycleState.resumed)
    {
      AudioHelper.instance.resumeMusic();
    }
    super.didChangeAppLifecycleState(state);
  }
@override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AudioHelper.instance.playMusic();
    super.initState();
  }

  @override
  void dispose() {
   WidgetsBinding.instance.removeObserver(this);
   AudioHelper.instance.disposeMusicPlayer();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Stack(
        children: [
          const SizedBox(),
          Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                const Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/mmheader.png",height: MediaQuery.of(context).size.height/2.2)),
                     BouncingTextButton(button:"assets/images/login.png" ,action: (){
                      Authservice.signInWithGoogle(context);
                     },),
                    const SizedBox(height:12 ,),
                    BouncingTextButton(button:"assets/images/exit.png" ,action: (){
                      AudioHelper.instance.disposeMusicPlayer();
                    },),
                    SizedBox(height:MediaQuery.of(context).size.height/18 ,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BouncingIconButton(button: "assets/images/mute.png", action: (){},alt: "assets/images/unmute.png",),
                        const SizedBox(width: 12,),
                        BouncingIconButton(button: "assets/images/terms.png", action: (){},),
                        const SizedBox(width: 12,),
                         BouncingIconButton(button: "assets/images/contact.png", action: (){},),
                      ],
                    ),
                  const Spacer()
                ],
               ),
             ]));
           }
  
  
}

