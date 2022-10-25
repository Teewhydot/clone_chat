
import 'package:flutter/material.dart';

class UserNameProvider extends ChangeNotifier {
  String userName = '';
  String get name => userName;
  void setName(String value) {
    userName = value;
    notifyListeners();
  }
}