// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Functions/firebase_functions.dart';
import 'package:flash_chat/Models/constants.dart';
import 'package:flash_chat/UI/chat-screen.dart';
import 'package:flash_chat/providers/delete_clone_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flash_chat/Reusables/palettes.dart';

class ConversationList extends StatefulWidget {
  final String name;

  const ConversationList(this.name, {Key? key}) : super(key: key);
  @override
  ConversationListState createState() => ConversationListState();
}

class ConversationListState extends State<ConversationList> {
  final fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    ToastContext().init(context);
    Widget buildAlertDialog(BuildContext context) {
      final deleteProvider = Provider.of<DeleteCloneProvider>(context,listen: false);
      final isSpinningProvider =Provider.of<DeleteCloneProvider>(context);
      final nav = Navigator.of(context);
      bool hasInternet;
      return AlertDialog(
        title: const Text('Warning'),
        content: const Text(
            'Are you sure you want to delete this clone? This action is irreversible'),
        actions: [
          SizedBox(
            width: 75.w,
            height: 25.h,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('NO'),
            ),
          ),
          SizedBox(
            width: 75.w,
            height: 25.h,
            child: ElevatedButton(
                child: isSpinningProvider.spinning
                    ? const LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: [Colors.white],
                        strokeWidth: 2,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: Colors.transparent)
                    : const Text('Yes'),
                onPressed: () async {
                  hasInternet = await InternetConnectionChecker().hasConnection;
                  if (hasInternet) {
                   deleteProvider.setSpinning(true);
                    await deleteClone(widget.name,context);
                    nav.pop();
                    Toast.show("Clone deleted",
                        duration: Toast.lengthShort,
                        gravity: Toast.center,
                        backgroundColor: Colors.amberAccent.shade700);
                   deleteProvider.setSpinning(false);
                  } else {
                    deleteProvider.setSpinning(false);
                    Toast.show("No internet connection",
                        duration: Toast.lengthShort,
                        gravity: Toast.center,
                        backgroundColor: Colors.amberAccent.shade700);
                  }
                }),
          ),
        ],
      );
    }

    return GestureDetector(
      onLongPress: () {
        showDialog(context: context, builder: buildAlertDialog);
      },
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatScreen(widget.name)));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      maxRadius: 30.r,
                    ),
                    addHorizontalSpacing(15),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.name,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
