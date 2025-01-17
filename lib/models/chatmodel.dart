class ChatModel {
  final String role;
  final String message;

  ChatModel({required this.role, required this.message});

  // Factory method to create an instance from a JSON map
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      role: json['role'] as String,
      message: json['message'] as String,
    );
  }

  // Method to convert an instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'message': message,
    };
  }
}
