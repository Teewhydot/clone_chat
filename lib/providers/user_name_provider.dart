
import 'package:flutter/material.dart';

class UserNameProvider extends ChangeNotifier {
  String userName = '';
  String get name => userName;


  UserNameProvider(userNameFromStorage) {
    userName = userNameFromStorage;
    notifyListeners();
  }
  void setName(String value) {
    userName = value;
    notifyListeners();
  }
}