import 'package:eby/pages/characterpage.dart';
import 'package:eby/pages/modelloadpage.dart';


import 'package:eby/utils/sttservice.dart';
import 'package:eby/utils/ttsservice.dart';
import 'package:eby/utils/variablesprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TtsService()..initialize()),
        ChangeNotifierProvider(create: (_) => SpeechToTextService()..initialize()),
        ChangeNotifierProvider(create: (_)=>ModeProvider())
      ],
      child: const MyApp(),
    )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Eby-AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const  ModelLoadPage()
    );
  }
}


