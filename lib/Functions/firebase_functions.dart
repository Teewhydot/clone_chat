import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Models/chat_model.dart';
import 'package:flash_chat/providers/user_name_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> addMessageToFirebase(String message, BuildContext context,String cloneName) async {
  final fireStore = FirebaseFirestore.instance;
  final chatProviderListen = Provider.of<ChatProvider>(context,listen: false);
  final provider = Provider.of<UserNameProvider>(context,listen: false);

  String getUserStatus() {
    if (chatProviderListen.isClone) {
      return "receiver";
    } else {
      return "sender";
    }
  }


  await fireStore
      .collection(provider.name)
      .doc(provider.name)
      .collection('clones')
      .doc(cloneName)
      .collection('chats').add({
    'messageText': message,
    'whoSent': getUserStatus(),
    'time': DateTime.now(),
  });
}

Future<void> deleteClone(String cloneName,BuildContext context) {
  final nameProvider = Provider.of<UserNameProvider>(context,listen: false);
  final fireStore = FirebaseFirestore.instance;
  return fireStore.collection(nameProvider.name).doc(nameProvider.name).collection('clones').doc(cloneName).delete();
}

Future<void> addCloneToFirebase(String cloneName) async {
  final fireStore = FirebaseFirestore.instance;

  await fireStore.collection('provider.name').doc('provider.name')
      .collection('clones')
      .doc(cloneName)
      .collection('chats')
      .add({
        'messageText':
            'Hello, I am your new clone $cloneName, Tap the switch on the top right corner of your screen to switch places with me.',
        'whoSent': 'receiver',
        'time': DateTime.now(),
      });
}

Future<bool> checkExist(String cloneId,BuildContext context) async {
  bool exist = false;
  final provider = Provider.of<UserNameProvider>(context,listen: false);
  final fireStore = FirebaseFirestore.instance;
//checks if the clone name already exists, returns true if yes and false if no.
  await fireStore
      .collection(provider.name)
      .doc(provider.name).collection('clones').doc(cloneId)
      .get()
      .then((value) => exist = value.exists);
  return exist;
}