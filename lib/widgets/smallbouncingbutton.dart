import 'dart:developer';

import 'package:eby/utils/audiohelper.dart';
import 'package:flutter/material.dart';

class SmallBouncingTextButton extends StatefulWidget {
  final String button;
  final Function action;
  const SmallBouncingTextButton({
    super.key, required this.button, required this.action,
  });
  @override
  State<SmallBouncingTextButton> createState() => _SmallBouncingTextButtonState();
}

class _SmallBouncingTextButtonState extends State<SmallBouncingTextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this,);
    _buttonAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: Tween(begin: 1, end: 1.2), weight: 50),
      TweenSequenceItem<double>(tween: Tween(begin: 1.2, end: 1), weight: 50)
    ]).animate( CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _controller.addListener(() {
      log(_buttonAnimation.value.toString());
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return GestureDetector(
            onTap: () {
              AudioHelper.instance.playTextButtonClick();
             _controller.forward();
             widget.action();
            },
            child: ScaleTransition(
                scale: _buttonAnimation,
                child: Image.asset(
                  widget.button,
                  width: (MediaQuery.of(context).size.width / 2.6),
                )));
      },
    );
  }
}
