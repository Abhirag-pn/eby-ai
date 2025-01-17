import 'chatmodel.dart';

class ChatSessionModel {
  final DateTime sessionDate;
  final String id;
  final List<ChatModel> messages;

  ChatSessionModel( {required this.sessionDate, required this.messages,required this.id,});

  // Factory constructor to create an instance from a JSON map
  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id:json['id'] ,
      sessionDate: DateTime.parse(json['sessionDate']),
      messages: (json['messages'] as List)
          .map((message) => ChatModel.fromJson(message))
          .toList(),
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'sessionDate': sessionDate.toIso8601String(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
