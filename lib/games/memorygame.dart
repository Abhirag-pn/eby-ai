import 'dart:async';
import 'package:flutter/material.dart';

class MemoryCardGame extends StatelessWidget {
  const MemoryCardGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green[50],
        body: const Center(
          child: GameScreen(),
        ),
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
  List<String> emojis = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'];
  late List<String> cards;
  List<bool> cardFlips = [];
  List<int> matchedCards = [];
  int? firstSelectedIndex;
  int moves = 0;
  int matches = 0;
  bool isProcessing = false;
  Timer? gameTimer;
  int secondsElapsed = 0;
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void initializeGame() {
    cards = List.filled(16, '');
    cardFlips = List.generate(16, (index) => false);
    matchedCards = [];
    moves = 0;
    matches = 0;
    firstSelectedIndex = null;
    secondsElapsed = 0;
    gameStarted = false;
    gameTimer?.cancel();
  }

  void startGame() {
    setState(() {
      cards = [...emojis, ...emojis];
      cards.shuffle();
      gameStarted = true;
      gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          secondsElapsed++;
        });
      });
    });
  }

  void restartGame() {
    setState(() {
      initializeGame();
    });
  }

  void onCardTap(int index) {
    if (!gameStarted || isProcessing || cardFlips[index] || matchedCards.contains(index)) {
      return;
    }

    setState(() {
      cardFlips[index] = true;
      
      if (firstSelectedIndex == null) {
        firstSelectedIndex = index;
      } else {
        moves++;
        if (cards[firstSelectedIndex!] == cards[index]) {
          matchedCards.add(firstSelectedIndex!);
          matchedCards.add(index);
          matches++;
          firstSelectedIndex = null;
          
          if (matches == emojis.length) {
            gameTimer?.cancel();
          }
        } else {
          isProcessing = true;
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              cardFlips[firstSelectedIndex!] = false;
              cardFlips[index] = false;
              firstSelectedIndex = null;
              isProcessing = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🎮 Memory Match 🎮',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.black,
                fontFamily: 'Bowl'
              ),
            ),
            const SizedBox(height: 20),
            
            // Score Board
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withAlpha(30),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Moves',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: 'Bowl'
                        ),
                      ),
                      Text(
                        '$moves',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontFamily: 'Bowl'
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Time',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: 'Bowl'
                        ),
                      ),
                      Text(
                        '${secondsElapsed}s',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontFamily: 'Bowl'
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Game Grid
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withAlpha(20),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onCardTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: matchedCards.contains(index)
                              ? Colors.green[100]
                              : cardFlips[index]
                                  ? Colors.white
                                  : Colors.green[300],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withAlpha(30),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            cardFlips[index] ? cards[index] : '❓',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Game Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: !gameStarted ? startGame : restartGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !gameStarted ? Colors.green : Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    !gameStarted ? 'Start Game' : 'Restart',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontFamily: 'Bowl'
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Exit',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontFamily: 'Bowl'
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}