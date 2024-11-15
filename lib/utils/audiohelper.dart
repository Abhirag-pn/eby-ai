import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  AudioHelper._privateConstructor();
  static final AudioHelper _instance = AudioHelper._privateConstructor();
  AudioPlayer buttonPlayer = AudioPlayer();
  AudioPlayer musicPlayer = AudioPlayer();
  
  static AudioHelper get instance => _instance;

  // Method to play text button click sound
  void playTextButtonClick() async {
    log("Playing");
    await buttonPlayer.setSource(AssetSource('sounds/buttonclick.mp3'));
    buttonPlayer.resume();
  }

  // Method to play background music with loop
  void playMusic() async {
    await musicPlayer.setSource(AssetSource('sounds/musictrack.mp3'));
    musicPlayer.setReleaseMode(ReleaseMode.loop);
    musicPlayer.resume();  // Corrected to play the musicPlayer
  }

  // Method to stop background music
  void stopBackgroundMusic() {
    musicPlayer.stop();
  }

 void dispose() {
    buttonPlayer.dispose();
    musicPlayer.dispose();
  }

}

