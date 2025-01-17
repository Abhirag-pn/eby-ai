import 'package:eby/pages/chatpage.dart';
import 'package:flutter/material.dart';

class SessionWidget extends StatelessWidget {
  final String date, sessionID;

  const SessionWidget({
    super.key,
    required this.date,
    required this.sessionID,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return Scaffold(
                  body: ChatPage(
                    sessionID: sessionID,
                  ),
                  backgroundColor: Colors.transparent,
                );
              });
        },
        child: AnimatedContainer(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 90, 130, 205),
                Color.fromARGB(255, 50, 151, 245),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "$date\nTime: 10:00 AM", // Add time here
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        'Bowl', // Ensure the font is added in pubspec.yaml
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 24.0, // Adjusted size for better visibility
              ),
            ],
          ),
        ),
      ),
    );
  }
}
