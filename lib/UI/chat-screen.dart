// ignore_for_file: use_build_context_synchronously

import 'package:flash_chat/Functions/firebase_functions.dart';
import 'package:flash_chat/Models/chat_model.dart';
import 'package:flash_chat/Models/constants.dart';
import 'package:flash_chat/Reusables/palettes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String cloneName;
  final String userName;
  const ChatScreen(this.cloneName, this.userName, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Stream<QuerySnapshot> chatStream;
  bool isSending = false;
  void startSpinning() {
    setState(() {
      isSending = true;
    });
  }

  void stopSpinning() {
    setState(() {
      isSending = false;
    });
  }

  final fireStore = FirebaseFirestore.instance;
  final TextEditingController chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatStream = fireStore
        .collection(widget.userName)
        .doc(widget.userName)
        .collection('clones')
        .doc(widget.cloneName)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    bool hasInternet;
    ToastContext().init(context);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final chatProviderListen = Provider.of<ChatProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7.r),
                    bottomRight: Radius.circular(7.r)),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [appBarColor1, appBarColor2])),
          ),
          centerTitle: true,
          elevation: 0,
          title: Text(widget.cloneName),
          actions: [
            Switch.adaptive(
                value: chatProviderListen.isClone,
                onChanged: (value) {
                  chatProvider.toggleSwitch(value);
                }),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: chatStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Align(
                          alignment: data['whoSent'] == "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: data['whoSent'] == "receiver"
                                        ? appBarColor1
                                        : appBarColor2,
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0.r),
                                  child: Column(
                                    children: [
                                      Text(
                                        data['whoSent'] == 'receiver'
                                            ? widget.cloneName
                                            : widget.userName,
                                        style: kWhiteTextStyle,
                                      ),
                                      addVerticalSpacing(5),
                                      Text(
                                        data['messageText'],
                                        style: kWhiteTextStyle,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  child: Row(
                    children: [
                      addHorizontalSpacing(10),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: chatController,
                          textInputAction: TextInputAction.send,
                          cursorColor: Colors.black,
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          onChanged: (newValue) {},
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                  style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(8.0.r),
                              child: GestureDetector(
                                  onTap: () async {
                                    startSpinning();
                                    hasInternet =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (chatController.text.isEmpty) {
                                      Toast.show("Cannot send an empty message",
                                          duration: Toast.lengthShort,
                                          gravity: Toast.center,
                                          backgroundColor: Colors.red);
                                      stopSpinning();
                                    } else if (hasInternet == false) {
                                      Toast.show("No internet connection",
                                          duration: Toast.lengthShort,
                                          gravity: Toast.center,
                                          backgroundColor: Colors.red);
                                      stopSpinning();
                                    } else {
                                      await addMessageToFirebase(
                                          chatController.text,
                                          context,
                                          widget.cloneName);
                                      chatController.clear();
                                      stopSpinning();
                                    }
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: appBarColor1,
                                      child: isSending
                                          ? const SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: LoadingIndicator(
                                                  indicatorType:
                                                      Indicator.semiCircleSpin,
                                                  colors: [Colors.white],
                                                  strokeWidth: 2,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  pathBackgroundColor:
                                                      Colors.transparent),
                                            )
                                          : const Icon(
                                              Icons.arrow_forward_ios))),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            hintText: 'Type Something...',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0.h, horizontal: 20.0.w),
                          ),
                        ),
                      ),
                      addHorizontalSpacing(10),
                    ],
                  ),
                ),
                addVerticalSpacing(10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
