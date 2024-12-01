import 'package:eby/pages/characterpage.dart';
import 'package:eby/pages/homepage.dart';
import 'package:eby/pages/mainmenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PageResolver extends StatelessWidget {
  const PageResolver({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for auth state
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          // If user is signed in, navigate to Homepage
          return const CharacterPage();
        } else if (snapshot.hasError) {
          // Handle errors gracefully
          return const Scaffold(
            body: Center(
              child: Text("An error occurred. Please try again."),
            ),
          );
        } else {
          // If no user is signed in, navigate to MainMenu
          return const MainMenu();
        }
      },
    );
  }
}
