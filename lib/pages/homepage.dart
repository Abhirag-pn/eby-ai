import 'dart:developer';

import 'package:eby/utils/audiohelper.dart';
import 'package:eby/utils/hotwordmanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // bool isActive = false;
  // late HotwordManager _hotwordManager;

  // void _wakeWordCallback(int keywordIndex) {
  //   log("Hotword detected on main screen! Index: $keywordIndex");
  //   setState(() {
  //     isActive = !isActive;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
    
  //   _hotwordManager = HotwordManager(onHotwordDetected: _wakeWordCallback);
  //   _hotwordManager.initialize();
  // }

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
          TextField(),
          ElevatedButton(onPressed: (){}, child: Text("Speak")),
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
