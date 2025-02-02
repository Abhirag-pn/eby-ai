import 'package:eby/utils/databaseservice.dart';
import 'package:eby/widgets/sessionwidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({
    super.key,
  });

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {

  
  Future<List<Map<String, dynamic>>> fetchMessages(String sessionID) async {
    // Fetch sessions from Firebase
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(sessionID)
        .collection('messages')
        .orderBy('timestamp', descending: true) // Ensure messages are in order

        .get();

    // Convert snapshot to list of maps
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchSessions() async {
    // Fetch sessions from Firebase
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .orderBy('sessionDate', descending: true)
        .get();

    // Convert snapshot to list of maps
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM d, y - h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
                future: DatabaseService.fetchSessions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white,));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No sessions yet.'));
                  }

                  final sessions = snapshot.data!;

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
                "Sessions",
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
                Container(
                
                   child:    Expanded(
                        child: ListView.builder(
                          
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            final sessionDate = formatDate(session.sessionDate);

                            return SessionWidget(
                                date: sessionDate, sessionID: session.id);
                          },
                        ),
                      ),
                )]
            ),
          ),
        ),
      ),
    );
                });
  }
}





   