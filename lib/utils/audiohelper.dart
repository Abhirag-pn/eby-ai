import 'package:audioplayers/audioplayers.dart';
import 'package:logger/web.dart';

class AudioHelper {
  AudioHelper._privateConstructor();
  static final AudioHelper _instance = AudioHelper._privateConstructor();

  static AudioHelper get instance => _instance;

  final AudioPlayer _buttonPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isMusicPlaying = false;

  Future<void> playMusic() async {
    if (_isMusicPlaying)
     {
      Logger().e("Already Playing ");
      return;
     }

     _isMusicPlaying = true;
     Logger().e("Playing ");
     await _musicPlayer.setVolume(0.2);
    await _musicPlayer.setSource(AssetSource('sounds/musictrack.mp3'));
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    _musicPlayer.resume();
    
  }

  Future<void> stopBackgroundMusic() async {
    if (_isMusicPlaying) {
      _isMusicPlaying = false;
      await _musicPlayer.stop();
      
    }
  
  }
  Future<void> pauseBackgroundMusic() async {
    if (_isMusicPlaying) {
      
      await _musicPlayer.stop();
      
    }}

   Future<void> resumeMusic() async {
    if (!_isMusicPlaying)
     {
      Logger().e("Muted");
      return;
     }

     _isMusicPlaying = true;
     Logger().e("Playing ");
     await _musicPlayer.audioCache.load('sounds/musictrack.mp3');
    await _musicPlayer.setVolume(0.2);
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    _musicPlayer.resume();
    
  }

  void disposeMusicPlayer() {
    Logger().e("Dispose called");


   stopBackgroundMusic();
    
    _musicPlayer.dispose();
  }
  void disposeButtonPlayer() {
    Logger().e("Dispose called");
    _buttonPlayer.dispose();
   
  }

  // Play button click sound
Future<void> playTextButtonClick() async {
    await _buttonPlayer.setSource(AssetSource('sounds/buttonclick.mp3'));
    _buttonPlayer.resume();
  }
}
