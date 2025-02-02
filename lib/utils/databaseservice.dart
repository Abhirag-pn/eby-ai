import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eby/models/chatmodel.dart';
import 'package:eby/models/chatsessionmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Ensure both models are imported

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Save a new chat session (creates a document in the 'chats' collection)
  static Future<String> saveChatSession() async {
    final chatDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(); // Auto-generate the session ID

    await chatDocRef.set({
      'id': chatDocRef.id,
      'sessionDate': FieldValue.serverTimestamp(), // Firestore Timestamp
    });

    return chatDocRef.id; // Return the session ID for further operations
  }

  // Add a message to the 'messages' subcollection for a specific chat session
  static Future<void> addMessageToSession(
      String sessionId, ChatModel chatModel) async {
    final messagesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(sessionId)
        .collection('messages');

    await messagesRef.add({
      'role': chatModel.role,
      'message': chatModel.message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fetch all chat sessions for the current user
  static Future<List<ChatSessionModel>> fetchSessions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .orderBy('sessionDate', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return []; // Return empty list if no data
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ChatSessionModel(
        id: data['id'],
        sessionDate: (data['sessionDate'] is Timestamp)
            ? (data['sessionDate'] as Timestamp).toDate() // Convert Timestamp to DateTime
            : DateTime.tryParse(data['sessionDate']) ?? DateTime.now(),
        messages: [], // Messages are not fetched here
      );
    }).toList();
  }

  // Fetch all messages for a specific chat session
  static Future<List<ChatModel>> getMessagesForSession(String sessionId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(sessionId)
        .collection('messages')
        .orderBy('timestamp')
        .get();

    if (snapshot.docs.isEmpty) {
      return []; // Return empty list if no messages
    }

    return snapshot.docs.map((doc) {
      final messageData = doc.data();
      return ChatModel.fromJson(messageData);
    }).toList();
  }
}
