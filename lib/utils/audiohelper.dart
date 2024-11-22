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
    try{
    if (_isMusicPlaying)
     {
      Logger().e("Already Playing ");
      return;
     }

     _isMusicPlaying = true;
     Logger().e("Playing ");
     await _musicPlayer.setVolume(0.1);
    await _musicPlayer.setSource(AssetSource('sounds/musictrack.mp3'));
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    _musicPlayer.resume();
    }catch(e)
    {
      Logger().e(e.toString());
    }
  }

  Future<void> stopBackgroundMusic() async {
    try{
    if (_isMusicPlaying) {
      _isMusicPlaying = false;
      await _musicPlayer.stop();
      
    }
    }catch(e)
    {
      Logger().e(e.toString());
    }
  }
  Future<void> pauseBackgroundMusic() async {
    try{
    if (_isMusicPlaying) {
      
      await _musicPlayer.stop();
      
    }
     }catch (e) 
     {

      Logger().e(e.toString());
     }}

   Future<void> resumeMusic() async {
    try{
    if (!_isMusicPlaying)
     {
      Logger().e("Muted");
      return;
     }

     _isMusicPlaying = true;
     Logger().e("Playing ");
     await _musicPlayer.audioCache.load('sounds/musictrack.mp3');
    await _musicPlayer.setVolume(0.1);
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    _musicPlayer.resume();
    }catch(e)
    {
       Logger().e(e.toString());
    }
  }

  void disposeMusicPlayer() {
    try{
    Logger().e("Dispose called");


   stopBackgroundMusic();
    
    _musicPlayer.dispose();}catch(e)
    {
      Logger().e(e.toString());
    }
  }
  void disposeButtonPlayer() {
    try{
    Logger().e("Dispose called");
    _buttonPlayer.dispose();
    }catch(e){Logger().e(e.toString());}
  }

Future<void> reduceMusicVol() async {try{
    _musicPlayer.setVolume(0.02);
  }catch(e){Logger().e(e.toString());}}

Future<void> increaseMusicVol() async {try{
    _musicPlayer.setVolume(0.2);
  }catch(e){Logger().e(e.toString());}}


  // Play button click sound
Future<void> playTextButtonClick() async {try{
    await _buttonPlayer.setSource(AssetSource('sounds/buttonclick.mp3'));
    _buttonPlayer.resume();
  }catch(e){Logger().e(e.toString());}}
}

