import 'dart:async';

import 'package:eby/games/components/ground.dart';
import 'package:eby/games/components/pipe.dart';
import 'package:eby/games/constants.dart';
import 'package:eby/games/flappybot.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';


class Bird extends SpriteComponent with CollisionCallbacks {
  Bird()
      : super(
            position: Vector2(birdStartX, birdStartY),
            size: Vector2(birdWidth, birdHeight));

  double velocity = 0;
  bool isUp = false;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('gameassets/bot.png');
    add(RectangleHitbox());
  }

  void flap() {
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    velocity += gravity * dt;

    position.y += velocity * dt;
    if (position.y < 0) {
      (parent as FlappyBotGame).gameOver();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      (parent as FlappyBotGame).gameOver();
    }

    if (other is Pipe) {
      (parent as FlappyBotGame).gameOver();
    }
  }
}