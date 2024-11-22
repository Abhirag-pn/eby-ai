import 'dart:developer';

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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: ()async{
            try{
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
