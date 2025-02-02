import 'dart:developer';
import 'package:eby/utils/authservice.dart';
import 'package:eby/widgets/bouncingiconbutton.dart';
import 'package:eby/widgets/bouncingtextbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/web.dart';

import '../utils/audiohelper.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AudioHelper.instance.pauseBackgroundMusic();
    }
    if (state == AppLifecycleState.resumed) {
      AudioHelper.instance.resumeMusic();
    }
    if (state == AppLifecycleState.detached){
      
      //  Databaseservice.saveMessage(ChatSessionModel(
      //     sessionDate: DateTime.now(),
      //     messages: Provider.of<ModeProvider>(context).messages));
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    log("INIT STARTED");
    WidgetsBinding.instance.addObserver(this);
    AudioHelper.instance.playMusic();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioHelper.instance.stopBackgroundMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg.jpg',
                ),
                fit: BoxFit.cover),
          ),
          child: Stack(children: [
            const SizedBox(),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/mmheader.png",
                        height: MediaQuery.of(context).size.height / 2.2)),
                BouncingTextButton(
                  button: "assets/images/login.png",
                  action: () {
                    try {
                      Authservice.signInWithGoogle(context);
                    } catch (e) {
                      Logger().e(e.toString());
                    }
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                BouncingTextButton(
                  button: "assets/images/exit.png",
                  action: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BouncingIconButton(
                      button: "assets/images/unmute.png",
                      action: () {},
                      alt: "assets/images/mute.png",
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    BouncingIconButton(
                      button: "assets/images/terms.png",
                      action: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    'assets/images/credits.png',
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                  ),
                                ));
                      },
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    BouncingIconButton(
                      button: "assets/images/contact.png",
                      action: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    'assets/images/feedback.png',
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                  ),
                                ));
                      },
                    ),
                  ],
                ),
                const Spacer()
              ],
            ),
          ]),
        ));
  }
}
