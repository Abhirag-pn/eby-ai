
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class PageResolver extends StatelessWidget {
  const PageResolver({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot)
    {
      
    },);
  }
}