import 'package:flutter/material.dart';

class DeleteCloneProvider extends ChangeNotifier {
  bool isSpinning = false;
  bool get spinning => isSpinning;
  void setSpinning(bool value) {
    isSpinning = value;
    notifyListeners();
  }
}
