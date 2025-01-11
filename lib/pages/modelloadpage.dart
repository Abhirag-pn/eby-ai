import 'dart:developer';

import 'package:eby/pages/characterpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';


class ModelLoadPage extends StatefulWidget {
  const ModelLoadPage({super.key});

  @override
  ModelLoadPageState createState() => ModelLoadPageState();
}

class ModelLoadPageState extends State<ModelLoadPage> {

  bool _isModelInitialized = false;
  int? _loadingProgress=0;


  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    log('entering model load');
    bool isLoaded = await FlutterGemmaPlugin.instance.isLoaded;
    if (!isLoaded) {
      await for (int progress in FlutterGemmaPlugin.instance.loadAssetModelWithProgress(fullPath: 'model.bin')) {
        setState(() {
          _loadingProgress = progress;
        });
      }
    }
    await FlutterGemmaPlugin.instance.init(

      maxTokens: 500,
      temperature: 0.5,
      topK: 1,
      randomSeed: 1,
    );
    setState(() {
      _isModelInitialized = true;
      log('model initialized');
    });
  }

  @override
  Widget build(BuildContext context) {
    return  
        _isModelInitialized
            ?const CharacterPage()
            : Scaffold(
      body: Container(
                decoration: const BoxDecoration(color: Colors.black),
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Getting Eby Ready $_loadingProgress %",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white, fontFamily: 'Bowl'),
                  
                  textAlign: TextAlign.center,),
                ),
              ),
    );
      
    
  }

}