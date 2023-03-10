import 'package:flutter/cupertino.dart';

class TimeAgoProvider extends ChangeNotifier {
  final String chatMessagesTime = '';
  final String firebaseChatTime = '';
  String get chatTime => chatMessagesTime;
  String get firebaseTime => firebaseChatTime;
}
