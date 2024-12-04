import 'package:rive/rive.dart';

class AnimationControllerService{
  late StateMachineController _controller;
  SMITrigger? _startListen, _startThink, _startSpeak, _startIdle,_startListenToSpeak;

  AnimationControllerService._private();
  static final instance=AnimationControllerService._private();
  factory AnimationControllerService()
  {
    return instance;
  }

  void initializeController(Artboard artboard) {
    _controller = StateMachineController.fromArtboard(
      artboard,
      'eby_state_machine',
    )!;
    artboard.addController(_controller);

    _startListen =
        _controller.findInput<bool>('start listening') as SMITrigger?;
    _startThink = _controller.findInput<bool>('start think') as SMITrigger?;
    _startSpeak = _controller.findInput<bool>('start speak') as SMITrigger?;
    _startIdle =
        _controller.findInput<bool>('go to idle normal') as SMITrigger?;
    _startListenToSpeak=_controller.findInput<bool>('listen to speak') as SMITrigger?;
  }

  void dispose()
  {
    _controller.dispose();
  }

  void triggerListen() => _startListen?.fire();
  void triggerListenToSpeak() => _startListenToSpeak?.fire();
  void triggerThink() => _startThink?.fire();
  void triggerSpeak() => _startSpeak?.fire();
  void triggerIdle() => _startIdle?.fire();
}
