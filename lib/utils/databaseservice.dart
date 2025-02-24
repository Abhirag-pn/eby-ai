import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eby/models/chatmodel.dart';
import 'package:eby/models/chatsessionmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<String> saveChatSession() async {
    final chatDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc();

    await chatDocRef.set({
      'id': chatDocRef.id,
      'sessionDate': FieldValue.serverTimestamp(),
    });

    return chatDocRef.id;
  }

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

  static Future<List<ChatSessionModel>> fetchSessions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .orderBy('sessionDate', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ChatSessionModel(
        id: data['id'],
        sessionDate: (data['sessionDate'] is Timestamp)
            ? (data['sessionDate'] as Timestamp).toDate()
            : DateTime.tryParse(data['sessionDate']) ?? DateTime.now(),
        messages: [],
      );
    }).toList();
  }

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
      return [];
    }

    return snapshot.docs.map((doc) {
      final messageData = doc.data();
      return ChatModel.fromJson(messageData);
    }).toList();
  }
}
