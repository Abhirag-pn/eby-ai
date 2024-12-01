import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eby/utils/geminiservice.dart';
import 'package:eby/utils/ttsservice.dart';
import 'package:eby/utils/sttservice.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final speechService = Provider.of<SpeechToTextService>(context);
    final geminiService = Provider.of<GeminiService>(context, listen: false);
    final ttsService = Provider.of<TtsService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Recognized words:', style: TextStyle(fontSize: 20.0)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                speechService.isListening
                    ? speechService.wordsSpoken
                    : speechService.speechEnabled
                        ? 'Tap the microphone to start listening...'
                        : 'Speech not available',
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (speechService.isListening) {
                  await speechService.stopListening();
                } else {
                 
                  await speechService.startListening();
                  log(speechService.wordsSpoken);
                final text=  await geminiService.sendMessage(speechService.wordsSpoken);
                log(text+"hello");
                  await ttsService.speak(text);
                  speechService.clearLastWords();
                }
              },
              child: Text(speechService.isListening ? "Stop Listening" : "Start Listening"),
            ),
            ElevatedButton(
              onPressed: () async {
                // When speech is detected, generate the response
                if (speechService.wordsSpoken.isNotEmpty) {
                  final response = await geminiService.sendMessage(speechService.wordsSpoken);
                  final cleanedResponse = cleanResponse(response);
                  log(cleanedResponse);
                  ttsService.speak(cleanedResponse);
                }
              },
              child: const Text("Ask Gemini"),
            ),
            ElevatedButton(
              onPressed: () {
                ttsService.stop();
              },
              child: const Text("Stop Speaking"),
            ),
          ],
        ),
      ),
    );
  }

  String cleanResponse(String response) {
    return response.replaceAll(RegExp(r'[^a-zA-Z0-9\s.,!?"]'), '');
  }
}
