import 'dart:developer';

import 'package:eby/utils/audiohelper.dart';
import 'package:flutter/material.dart';

class BouncingIconButton extends StatefulWidget {
  final String button;
  final Function action;
   final String? alt;
  const BouncingIconButton({
    super.key, required this.button, required this.action, this.alt,
  });
  @override
  State<BouncingIconButton> createState() => _BouncingTextButtonState();
}

class _BouncingTextButtonState extends State<BouncingIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _buttonAnimation;
  bool toggle=true;
  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _buttonAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: Tween(begin: 1, end: 1.2), weight: 50),
      TweenSequenceItem<double>(tween: Tween(begin: 1.2, end: 1), weight: 50)
    ]).animate(_controller);

    _controller.addListener(() {
      print(_buttonAnimation.value);
      setState(() {});
    });
    _controller.addStatusListener((state) {
      log(state.toString());
      if (state.isCompleted) {
        _controller.reset();
      }
    });
    super.initState();
  }
  @override
  void dispose() {
   _controller.dispose();
   AudioHelper.instance.disposeButtonPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return GestureDetector(
            onTap: () {
              
             _controller.forward();
             
          AudioHelper.instance.playTextButtonClick();
               toggle=!toggle;
               if(widget.alt==null)
               {
                widget.action();
               }else
               {
                toggle?AudioHelper.instance.playMusic():AudioHelper.instance.stopBackgroundMusic();
               }
            
            },
            child: ScaleTransition(
                scale: _buttonAnimation,
                child: Image.asset(
                  (widget.alt==null)? widget.button:(toggle?widget.button:widget.alt!),
                  width: (MediaQuery.of(context).size.width/5.5),
                )));
      },
    );
  }
}
