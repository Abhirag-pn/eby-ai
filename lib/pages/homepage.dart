import 'dart:developer';

import 'package:eby/utils/hotwordmanager.dart';
import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isActive = false;
  late HotwordManager _hotwordManager;

  void _wakeWordCallback(int keywordIndex) {
    log("Hotword detected on main screen! Index: $keywordIndex");
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  void initState() {
    super.initState();
    
    _hotwordManager = HotwordManager(onHotwordDetected: _wakeWordCallback);
    _hotwordManager.initialize();
  }

  @override
  void dispose() {
    _hotwordManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height / 13,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 5.0,
            colors: [
              Color.fromARGB(255, 68, 249, 74),
              Color.fromARGB(255, 29, 79, 30), // Normal green at the border
              // Dark green at the edge
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
     
        ),
     child: Center(
      child: Text("LOGIN",style: Theme.of(context).textTheme.titleLarge!.copyWith( shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 2),
                blurRadius: 4,
              )],color: Colors.white,fontWeight: FontWeight.bold),),
     ),
     
      )
      ),
    );
  }
}
