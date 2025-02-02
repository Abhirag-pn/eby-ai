import 'dart:async';
import 'package:eby/games/components/background.dart';
import 'package:eby/games/components/bird.dart';
import 'package:eby/games/components/ground.dart';
import 'package:eby/games/components/pipe.dart';
import 'package:eby/games/components/pipe_manager.dart';
import 'package:eby/games/components/score.dart';
import 'package:eby/games/constants.dart';
import 'package:eby/widgets/bouncingtextbutton.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class FlappyBotGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  final BuildContext parentContext;

  FlappyBotGame({required this.parentContext});

  @override
  FutureOr<void> onLoad() {
    background = Background(size);
    add(background);
    
    ground = Ground();
    add(ground);
    
    bird = Bird();
    add(bird);
    
    pipeManager = PipeManager();
    add(pipeManager);
    
    scoreText = ScoreText();
    add(scoreText);
  }

  @override
  void onTap() {
    bird.flap();
    if (isGameOver) {
      restartGame();
    }
  }

  int score = 0;
  void incrmentScore() {
    score += 1;
  }

  bool isGameOver = false;
  void gameOver() {
    if (isGameOver) {
      return;
    }
    isGameOver = true;
    pauseEngine();
    
    showDialog(
      barrierDismissible: false,
      context: buildContext!,
      builder: (ctx) => PopScope(
       canPop: false,
        child: Scaffold(
          backgroundColor: Colors.black54,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Score: $score",
                  style: Theme.of(ctx).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontFamily: 'Bowl',
                  )
                ),
                const SizedBox(height: 20),
                BouncingTextButton(
                  action: () {
                    Navigator.of(ctx).pop();
                    restartGame();
                  },
                  button: 'assets/images/restart.png',
                ),
                const SizedBox(height: 20),
                BouncingTextButton(
                  action: () {
                    Navigator.of(ctx).pop(); // Close the dialog
                    Navigator.of(parentContext).pop(); // Exit the game
                  },
                  button: 'assets/images/exit.png',
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  void restartGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    isGameOver = false;
    score = 0;
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    resumeEngine();
  }
}