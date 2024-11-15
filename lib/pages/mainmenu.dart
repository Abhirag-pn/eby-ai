
import 'dart:developer';

import 'package:eby/widgets/bouncingiconbutton.dart';
import 'package:eby/widgets/bouncingtextbutton.dart';
import 'package:flutter/material.dart';

import '../utils/audiohelper.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {


@override
  void initState() {
    AudioHelper.instance.playMusic();
    super.initState();
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
                    child: Image.asset("assets/images/mmheader.png",scale: MediaQuery.of(context).size.height/300)),
                     BouncingTextButton(button:"assets/images/login.png" ,action: (){},),
                    const SizedBox(height:12 ,),
                    BouncingTextButton(button:"assets/images/exit.png" ,action: (){},),
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

