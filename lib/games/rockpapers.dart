import 'dart:math';
import 'package:flutter/material.dart';

class RockPaperScissors extends StatelessWidget {
  const RockPaperScissors({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Colors.green[50]
      body: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final List<String> choices = ['✊', '✋', '✌️'];
  String playerChoice = '';
  String computerChoice = '';
  String result = '';
  late AnimationController _controller;
  int playerScore = 0;
  int computerScore = 0;
  bool isPlayingMove = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void playGame(String playerMove) {
    if (isPlayingMove) return;

    setState(() {
      isPlayingMove = true;
      playerChoice = playerMove;
      _controller.reset();
      _controller.forward();
      
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          computerChoice = choices[Random().nextInt(3)];
          result = determineWinner(playerChoice, computerChoice);
          if (result == 'You Win! 🎉') {
            playerScore++;
          } else if (result == 'You Lose! 😢') {
            computerScore++;
          }
          isPlayingMove = false;
        });
      });
    });
  }

  String determineWinner(String player, String computer) {
    if (player == computer) {
      return 'It\'s a Draw! 🤝';
    } else if (
        (player == '✊' && computer == '✌️') ||
        (player == '✌️' && computer == '✋') ||
        (player == '✋' && computer == '✊')
    ) {
      return 'You Win! 🎉';
    } else {
      return 'You Lose! 😢';
    }
  }

  void resetGame() {
    setState(() {
      playerChoice = '';
      computerChoice = '';
      result = '';
      playerScore = 0;
      computerScore = 0;
      isPlayingMove = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: constraints.maxHeight * 0.05),
                
                // Title
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '🎮 Rock Paper Scissors 🎮',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                      fontFamily: 'Bowl',
                      fontSize: isSmallScreen ? 24 : 32,
                    ),
                  ),
                ),
                
                SizedBox(height: constraints.maxHeight * 0.03),
                
                // Score Board
                Container(
                  padding: EdgeInsets.all(constraints.maxWidth * 0.03),
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
                      _buildScoreColumn('You', playerScore, context, isSmallScreen),
                      _buildScoreColumn('Computer', computerScore, context, isSmallScreen),
                    ],
                  ),
                ),
                
                SizedBox(height: constraints.maxHeight * 0.04),
                
                // Game Area
                Container(
                  padding: EdgeInsets.all(constraints.maxWidth * 0.04),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPlayerColumn('You', playerChoice, context, isSmallScreen),
                          Text(
                            'VS',
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontFamily: 'Bowl',
                              color: Colors.green,
                              fontSize: isSmallScreen ? 20 : 24,
                            ),
                          ),
                          _buildComputerColumn(context, isSmallScreen),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          result,
                          key: ValueKey<String>(result),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontFamily: 'Bowl',
                            fontSize: isSmallScreen ? 20 : 24,
                            color: result.contains('Win')
                                ? Colors.green
                                : result.contains('Lose')
                                    ? Colors.red
                                    : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: constraints.maxHeight * 0.04),
                
                // Controls
                Container(
                  padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Choose your move:',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontFamily: 'Bowl',
                          color: Colors.black87,
                          fontSize: isSmallScreen ? 20 : 24,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Wrap(
                        spacing: constraints.maxWidth * 0.03,
                        runSpacing: constraints.maxHeight * 0.02,
                        alignment: WrapAlignment.center,
                        children: choices.map((choice) => 
                          SizedBox(
                            width: isSmallScreen ? constraints.maxWidth * 0.25 : constraints.maxWidth * 0.2,
                            child: ElevatedButton(
                              onPressed: isPlayingMove ? null : () => playGame(choice),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(constraints.maxWidth * 0.03),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                choice,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 24 : 32,
                                ),
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: constraints.maxHeight * 0.02),
                
                // Buttons
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.06,
                          vertical: constraints.maxHeight * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Reset Game',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontFamily: 'Bowl',
                          fontSize: isSmallScreen ? 16 : 20,
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.06,
                          vertical: constraints.maxHeight * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Exit Game',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontFamily: 'Bowl',
                          fontSize: isSmallScreen ? 16 : 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreColumn(String label, int score, BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontFamily: 'Bowl',
            fontSize: isSmallScreen ? 16 : 20,
          ),
        ),
        Text(
          '$score',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontFamily: 'Bowl',
            fontSize: isSmallScreen ? 20 : 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerColumn(String label, String choice, BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontFamily: 'Bowl',
            fontSize: isSmallScreen ? 16 : 20,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            choice.isEmpty ? '❓' : choice,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontFamily: 'Bowl',
              fontSize: isSmallScreen ? 32 : 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComputerColumn(BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        Text(
          'Computer',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontFamily: 'Bowl',
            fontSize: isSmallScreen ? 16 : 20,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(15),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 4 * pi,
                child: Text(
                  computerChoice.isEmpty ? '🤖' : computerChoice,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontFamily: 'Bowl',
                    fontSize: isSmallScreen ? 32 : 40,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}