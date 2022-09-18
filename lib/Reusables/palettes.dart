import 'dart:math';

import 'package:flutter/material.dart';

const scaffoldBackgroundColor = Color(0xfff5f3f8);
const appBarColor1 = Color(0xff903aff);
const appBarColor2 = Color(0xffc94bff);
const buttonColor1 = Color(0xff903aff);
const textColor = Colors.white;
const chatColorSender = Color(0xffc94bff);
const chatColorReceiver = Color(0xff903aff);
const chatColorSenderText = Colors.white;
const chatColorReceiverText = Colors.white;

String avatarColor (){
  var list = ['blue', 'green', 'white', 'cyan', 'purple', 'red', 'orange', 'pink', 'yellow', 'grey', 'brown', 'black', 'teal', 'indigo', 'lime', 'amber', 'deepOrange', 'deepPurple', 'lightBlue', 'lightGreen', 'blueGrey'];
  final random = Random();
  var colorChoice = list[random.nextInt(list.length)];
  return colorChoice;
}