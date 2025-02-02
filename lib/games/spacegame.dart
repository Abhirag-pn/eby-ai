import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SpaceShooterGame extends StatelessWidget {
  const SpaceShooterGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  bool gameStarted = false;
  Timer? gameTimer;
  int timeLeft = 30;
  List<UFO> ufos = [];
  List<Explosion> explosions = [];
  final Random random = Random();
  List<Timer> ufoTimers = [];

  // Initialize with default values instead of using late
  double ufoSize = 40;
  double explosionSize = 40;
  double starSize = 5;
  double buttonHeight = 30;
  double buttonWidth = 120;
  double titleSize = 30;
  double scoreSize = 20;
  double infoBoxSize = 20;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateResponsiveSizes();
  }

  void _updateResponsiveSizes() {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    
    setState(() {
      ufoSize = shortestSide * 0.08;
      explosionSize = shortestSide * 0.08;
      starSize = shortestSide * 0.01;
      buttonHeight = shortestSide * 0.06;
      buttonWidth = shortestSide * 0.25;
      titleSize = shortestSide * 0.06;
      scoreSize = shortestSide * 0.04;
      infoBoxSize = shortestSide * 0.04;
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    for (var timer in ufoTimers) {
      timer.cancel();
    }
    ufoTimers.clear();
    super.dispose();
  }

  void startGame() {
    if (!mounted) return;

    setState(() {
      score = 0;
      timeLeft = 30;
      ufos.clear();
      explosions.clear();
      gameStarted = true;
    });

    gameTimer?.cancel();
    for (var timer in ufoTimers) {
      timer.cancel();
    }
    ufoTimers.clear();

    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
          if (random.nextDouble() < 0.7) {
            spawnUFO();
          }
        } else {
          endGame();
        }
      });
    });
  }

  void endGame() {
    if (!mounted) return;

    gameTimer?.cancel();
    for (var timer in ufoTimers) {
      timer.cancel();
    }
    ufoTimers.clear();

    setState(() {
      gameStarted = false;
    });
  }

  void spawnUFO() {
    if (!mounted) return;
    if (ufos.length >= 8) return;

    final size = MediaQuery.of(context).size;
    final startFromTop = random.nextBool();
    final startFromLeft = random.nextBool();

    double startX = startFromLeft ? -ufoSize : size.width;
    double startY = startFromTop ? -ufoSize : size.height;

    double endX = startFromLeft ? size.width + ufoSize : -ufoSize;
    double endY = startFromTop ? size.height + ufoSize : -ufoSize;

    endX += random.nextDouble() * size.width * 0.2 - size.width * 0.1;
    endY += random.nextDouble() * size.height * 0.2 - size.height * 0.1;

    final ufo = UFO(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startX: startX,
      startY: startY,
      endX: endX,
      endY: endY,
      duration: Duration(seconds: random.nextInt(4) + 2),
    );

    if (mounted) {
      setState(() {
        ufos.add(ufo);
      });
    }

    final ufoTimer = Timer(ufo.duration, () {
      if (mounted) {
        setState(() {
          ufos.removeWhere((a) => a.id == ufo.id && !a.destroyed);
        });
      }
    });
    ufoTimers.add(ufoTimer);
  }

  void destroyUFO(UFO ufo) {
    if (!mounted) return;
    if (ufo.destroyed) return;

    setState(() {
      ufo.destroyed = true;
      ufos.removeWhere((a) => a.id == ufo.id);
      score++;

      explosions.add(Explosion(
        id: ufo.id,
        x: ufo.currentX ?? ufo.startX,
        y: ufo.currentY ?? ufo.startY,
      ));
    });

    final explosionTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          explosions.removeWhere((e) => e.id == ufo.id);
        });
      }
    });
    ufoTimers.add(explosionTimer);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          return false;
        }
        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Starfield background
              ...List.generate(50, (index) {
                return Positioned(
                  left: random.nextDouble() * constraints.maxWidth,
                  top: random.nextDouble() * constraints.maxHeight,
                  child: Text(
                    '✦',
                    style: TextStyle(
                      fontSize: starSize,
                      color: Colors.white.withOpacity(0.5 + random.nextDouble() * 0.5),
                    ),
                  ),
                );
              }),

              // Score and Timer
              Positioned(
                top: constraints.maxHeight * 0.05,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoBox('🎯', score.toString()),
                    _buildInfoBox('⏳', timeLeft.toString(),
                        color: timeLeft <= 10 ? Colors.red[300] : Colors.white),
                  ],
                ),
              ),

              // UFOs
              if (gameStarted)
                ...ufos.map((ufo) => TweenAnimationBuilder<Offset>(
                      tween: Tween(
                        begin: Offset(ufo.startX, ufo.startY),
                        end: Offset(ufo.endX, ufo.endY),
                      ),
                      duration: ufo.duration,
                      builder: (context, offset, child) {
                        ufo.currentX = offset.dx;
                        ufo.currentY = offset.dy;

                        if (ufo.destroyed) return const SizedBox.shrink();

                        return Positioned(
                          left: offset.dx,
                          top: offset.dy,
                          child: GestureDetector(
                            onTap: () => destroyUFO(ufo),
                            child: Text(
                              '🛸',
                              style: TextStyle(fontSize: ufoSize),
                            ),
                          ),
                        );
                      },
                    )),

              // Explosions
              ...explosions.map((explosion) => Positioned(
                    left: explosion.x - explosionSize / 2,
                    top: explosion.y - explosionSize / 2,
                    child: Text(
                      '💥',
                      style: TextStyle(fontSize: explosionSize),
                    ),
                  )),

              // Game start/end overlay
              if (!gameStarted)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.purple.withOpacity(0.2),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '🛸 Space Defender 🛸',
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        if (score > 0)
                          Padding(
                            padding: EdgeInsets.all(constraints.maxHeight * 0.03),
                            child: Text(
                              'UFOs Destroyed: $score',
                              style: TextStyle(
                                fontSize: scoreSize,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        _buildControlButtons(constraints),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoBox(String icon, String value, {Color? color}) {
    return Container(
      padding: EdgeInsets.all(infoBoxSize * 0.4),
      decoration: BoxDecoration(
        color: Colors.indigo[900]?.withValues(alpha: 80),
        borderRadius: BorderRadius.circular(infoBoxSize),
        border: Border.all(color: Colors.purple[200]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 30),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: infoBoxSize)),
          SizedBox(width: infoBoxSize * 0.2),
          Text(
            value,
            style: TextStyle(
              fontSize: infoBoxSize * 1.2,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(BoxConstraints constraints) {
    return Wrap(
      spacing: constraints.maxWidth * 0.05,
      runSpacing: constraints.maxHeight * 0.02,
      alignment: WrapAlignment.center,
      children: [
        _buildGameButton(
          onPressed: startGame,
          color: Colors.purple,
          text: score == 0 ? '🎮 Start Mission' : '🎮 Play Again',
        ),
        _buildGameButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          color: Colors.red[700]!,
          text: '🚪 Exit',
        ),
      ],
    );
  }

  Widget _buildGameButton({
    required VoidCallback onPressed,
    required Color color,
    required String text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonHeight * 0.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(
            horizontal: buttonWidth * 0.2,
            vertical: buttonHeight * 0.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonHeight * 0.5),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: buttonHeight * 0.4,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class UFO {
  final String id;
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final Duration duration;
  double? currentX;
  double? currentY;
  bool destroyed;

  UFO({
    required this.id,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.duration,
    this.destroyed = false,
  });
}

class Explosion {
  final String id;
  final double x;
  final double y;

  Explosion({
    required this.id,
    required this.x,
    required this.y,
  });
}