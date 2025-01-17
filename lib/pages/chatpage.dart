import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  final String sessionID;

  const ChatPage({super.key, required this.sessionID});

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    // Fetch sessions from Firebase
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(sessionID)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Ensure messages are in order
        .get();

    // Convert snapshot to list of maps
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp != null) {
      try {
        DateTime dateTime = (timestamp as Timestamp).toDate();
        // Format the date-time as per your requirement
        return DateFormat('MMMM d, yyyy h:mm a').format(dateTime);
      } catch (e) {
        print('Error formatting timestamp: $e');
      }
    }
    return ''; // Return an empty string if the timestamp is null or invalid
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 40, bottom: 10, left: 20, right: 20),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/chatbg.png'), fit: BoxFit.fill)),
      child: Column(
        children: [
          Text(
            "Messages",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontFamily: 'Bowl'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.4,
            width: double.maxFinite,
            child: FutureBuilder(
              future: fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white)),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No messages yet.',
                        style: TextStyle(color: Colors.white)),
                  );
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message['role'] == 'user'; // Check role
                    final text = message['message'] ?? '';
                    final timestamp = formatTimestamp(message['timestamp']);

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                color: isUser
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              timestamp,
                              style: TextStyle(
                                color: isUser
                                    ? Colors.white70
                                    : Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
