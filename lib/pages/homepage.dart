import 'dart:developer';

import 'package:eby/utils/audiohelper.dart';
import 'package:eby/utils/hotwordmanager.dart';
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
  final _speechController=TextEditingController();
  late final ttsService ;
  bool isInitialised=false;
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
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _speechController,
          ),
          ElevatedButton(onPressed: (){
            log("clicked");
           Provider.of<TtsService>(context,listen: false).speak(_speechController.text);
          }, child: Text("Speak")),
          ElevatedButton(onPressed: ()async{
            try{
              AudioHelper.instance.resumeMusic();
               await FirebaseAuth.instance.signOut();
            }catch (e){
              Logger().d(e.toString());
            }
           
          }, child: Text("Logout",style: TextStyle(color: Colors.red),))
        ],
      )
    );
  }
}
