import 'package:eby/models/chatmodel.dart';
import 'package:flutter/material.dart';

class ModeProvider with ChangeNotifier {
  bool _studymode = false;
    List<ChatModel>messages=[];

  bool get studyMode => _studymode;

  void toggleMode() {
    _studymode = !_studymode;
    notifyListeners(); // Notify listeners to rebuild UI where this value is used
  }
  void addMessage(ChatModel message) {
    messages.add(message);
    notifyListeners(); // Notify listeners to rebuild UI where this value is used
  }
}
