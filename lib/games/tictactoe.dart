import 'package:flutter/material.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame>
    with SingleTickerProviderStateMixin {
  List<String> board = List.filled(9, ''); // 3x3 board
  bool isXTurn = true;
  String winner = '';
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = '';
    });
  }

  void checkWinner() {
    List<List<int>> winningCombos = [
      [0, 1, 2], // Row 1
      [3, 4, 5], // Row 2
      [6, 7, 8], // Row 3
      [0, 3, 6], // Column 1
      [1, 4, 7], // Column 2
      [2, 5, 8], // Column 3
      [0, 4, 8], // Diagonal 1
      [2, 4, 6], // Diagonal 2
    ];

    for (var combo in winningCombos) {
      if (board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]] &&
          board[combo[0]] != '') {
        setState(() {
          winner = board[combo[0]];
        });
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        winner = 'Draw';
      });
    }
  }

  void makeMove(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
        checkWinner();
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withValues(alpha: 10),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title Text
               Text(
                '🎉 TIC TAC TOE 🎉',
                 style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.green, fontFamily: 'Bowl'),
              ),
              const SizedBox(height: 20),
              // Status Text
              Text(
                winner.isNotEmpty
                    ? (winner == 'Draw' ? 'It\'s a Draw!' : '$winner Wins!')
                    : (isXTurn ? 'X\'s Turn' : 'O\'s Turn'),
                style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.blue, fontFamily: 'Bowl'),
              ),
              const SizedBox(height: 30),
              // Responsive Game Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  double gridSize = constraints.maxWidth > constraints.maxHeight
                      ? constraints.maxHeight * 0.2
                      : constraints.maxWidth * 0.8;

                  return Center(
                    child: SizedBox(
                      width: gridSize,
                      height: gridSize,
                      child: GridView.builder(
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                        itemCount: 9,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => makeMove(index),
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                    border: Border.all(
                                        color: Colors.white, width: 4),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      board[index],
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: board[index] == 'X'
                                            ? Colors.orange
                                                : Colors.yellow,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(
                                                _controller.value * 2,
                                                _controller.value * 2),
                                            blurRadius: 10,
                                            color: board[index] == 'X'
                                                ? const Color.fromARGB(255, 109, 69, 9)
                                                : const Color.fromARGB(255, 163, 148, 11),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              // Restart Button
              ElevatedButton(
                onPressed: resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                ),
                child: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                ),
                child: const Text(
                  'Exit',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
