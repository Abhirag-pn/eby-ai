import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eby/models/chatsessionmodel.dart';
import 'package:eby/models/chatmodel.dart'; // Ensure ChatModel is imported
import 'package:firebase_auth/firebase_auth.dart';

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
      'id':chatDocRef.id,
      'sessionDate': DateTime.now().toIso8601String(),
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
  static Future<List<ChatSessionModel>> getChatSessions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .get();

    final sessions = snapshot.docs.map((doc) {
      final sessionData = doc.data();
      return ChatSessionModel(
        id:sessionData['id'],
        sessionDate: DateTime.parse(sessionData['sessionDate']),
        messages: [], // Messages are not fetched here
      );
    }).toList();

    return sessions;
  }

  // Fetch all messages for a specific chat session
  static Future<List<ChatModel>> getMessagesForSession(String sessionId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(sessionId)
        .collection('messages')
        .orderBy('timestamp',)
        .get();

    final messages = snapshot.docs.map((doc) {
      final messageData = doc.data();
      return ChatModel.fromJson(messageData);
    }).toList();

    return messages;
  }
}
