import 'package:flutter/material.dart';

class ModeProvider with ChangeNotifier {
  bool _studymode = false;

  bool get studyMode => _studymode;

  void toggleMode() {
    _studymode = !_studymode;
    notifyListeners(); // Notify listeners to rebuild UI where this value is used
  }
}
