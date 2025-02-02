import 'package:eby/games/rockpapers.dart';
import 'package:eby/games/spacegame.dart';
import 'package:eby/games/tictactoe.dart';
import 'package:eby/main.dart';
import 'package:flutter/material.dart';



class ChooseGameScreen extends StatelessWidget {
  const ChooseGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      border: Border.all(color: Colors.white, width: 5),
     ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Scaffold(
          backgroundColor: Colors.green, // Full-screen background
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
              Text(
                "Choose Game",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white, fontFamily: 'Bowl'),
              ), 
              const SizedBox(width: 20),
               GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close,color: Colors.white,))  ],
                ),
                const Divider(color: Colors.white,thickness: 3,),
               const SizedBox(
                  height: 10,
                ),
                _buildGameOption(context, "Tic Tac Toe", const TicTacToeGame()),
                _buildGameOption(context, "Rock Papers", const RockPaperScissors()),
                _buildGameOption(context, "Space Shooter", const SpaceShooterGame()),
                _buildGameOption(context, "Flappy Bot", const MyApp2()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOption(BuildContext context, String title, Widget gamePage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => gamePage));
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), // Rounded corners
            border: Border.all(color: Colors.white, width: 2), // White stroke
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20,fontFamily: 'Bowl'),
          ),
        ),
      ),
    );
  }
}
