import 'package:eby/pages/characterpage.dart';
import 'package:eby/pages/homepage.dart';
import 'package:eby/pages/pageresolver.dart';

import 'package:eby/utils/geminiservice.dart';
import 'package:eby/utils/sttservice.dart';
import 'package:eby/utils/ttsservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (_) => TtsService()..initialize()),
       
        ChangeNotifierProvider(create: (_) => SpeechToTextService()..initialize()),
      ],
      child: const MyApp(),
    )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eby-AI',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PageResolver()
    );
  }
}


