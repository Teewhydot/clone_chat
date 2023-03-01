import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  bool isSwitchedOn = false;
  bool get isClone => isSwitchedOn == true;

  void toggleSwitch(bool isSwitchOn) {
    isSwitchedOn = isSwitchOn == true ? true : false;
    notifyListeners();
  }
}
