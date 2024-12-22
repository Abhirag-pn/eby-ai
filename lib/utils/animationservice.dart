import 'package:rive/rive.dart';

class AnimationControllerService {
  late StateMachineController _controller;
  SMITrigger? _startListen,
      _startThink,
      _startSpeak,
      _startIdle,
      _startListenToSpeak,
      _startStudyMode,
      _startStudyIdle,
      _startStudySpeak,
      _startStudyListen,
      _startStudyThink,
      _startStudyListenToSpeak,
      _startStudyIdleToIdle,
      _startIdleToStudyIdle;

  AnimationControllerService._private();
  static final instance = AnimationControllerService._private();

  factory AnimationControllerService() {
    return instance;
  }

  void initializeController(Artboard artboard) {
    _controller = StateMachineController.fromArtboard(
      artboard,
      'eby_state_machine',
    )!;
    artboard.addController(_controller);

    _startStudyMode =
        _controller.findInput<bool>('start study mode') as SMITrigger?;
    _startStudyIdle =
        _controller.findInput<bool>('start study idle') as SMITrigger?;
    _startStudySpeak =
        _controller.findInput<bool>('start study speak') as SMITrigger?;
    _startStudyListen =
        _controller.findInput<bool>('start study listen') as SMITrigger?;
    _startStudyThink =
        _controller.findInput<bool>('start study think') as SMITrigger?;
    _startStudyListenToSpeak =
        _controller.findInput<bool>('study listen to speak') as SMITrigger?;
    _startStudyIdleToIdle =
        _controller.findInput<bool>('study idle to idle') as SMITrigger?;
    _startIdleToStudyIdle =
        _controller.findInput<bool>('idle to study idle') as SMITrigger?;
    _startListen = _controller.findInput<bool>('start listen') as SMITrigger?;
    _startThink = _controller.findInput<bool>('start think') as SMITrigger?;
    _startSpeak = _controller.findInput<bool>('start speak') as SMITrigger?;
    _startIdle = _controller.findInput<bool>('start idle') as SMITrigger?;
    _startListenToSpeak =
        _controller.findInput<bool>('listen to speak') as SMITrigger?;
  }

  void dispose() {
    _controller.dispose();
  }

  void triggerListen() => _startListen?.fire();
  void triggerListenToSpeak() => _startListenToSpeak?.fire();
  void triggerThink() => _startThink?.fire();
  void triggerSpeak() => _startSpeak?.fire();
  void triggerIdle() => _startIdle?.fire();
  void triggerStudyMode() => _startStudyMode?.fire();
  void triggerStudyIdle() => _startStudyIdle?.fire();
  void triggerStudySpeak() => _startStudySpeak?.fire();
  void triggerStudyListen() => _startStudyListen?.fire();
  void triggerStudyThink() => _startStudyThink?.fire();
  void triggerStudyListenToSpeak() => _startStudyListenToSpeak?.fire();
  void triggerStudyIdleToIdle() => _startStudyIdleToIdle?.fire();
  void triggerIdleToStudyIdle() => _startIdleToStudyIdle?.fire();
}
