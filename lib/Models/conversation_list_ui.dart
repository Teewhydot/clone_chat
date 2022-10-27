// ignore_for_file: use_build_context_synchronously, file_names

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






class ConversationList extends StatefulWidget {
  final String cloneNameFromFirestore;
  final String userName;

  const ConversationList(this.cloneNameFromFirestore, this.userName, {super.key});
  @override
  ConversationListState createState() => ConversationListState();
}

class ConversationListState extends State<ConversationList> {
  final fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    ToastContext().init(context);
    Widget buildAlertDialog(BuildContext context) {
      final provider = Provider.of<DeleteCloneProvider>(context,listen: false);
      final providerA = Provider.of<DeleteCloneProvider>(context,listen: false);
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
                nav.pop();
              },
              child: const Text('NO'),
            ),
          ),
          SizedBox(
            width: 75.w,
            height: 25.h,
            child: ElevatedButton(
                child: provider.spinning
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
                    provider.setSpinning(true);
                    await deleteClone(widget.cloneNameFromFirestore,context);
                    nav.pop();
                    Toast.show("Clone deleted",
                        duration: Toast.lengthShort,
                        gravity: Toast.center,
                        backgroundColor: Colors.amberAccent.shade700);
                   providerA.setSpinning(false);
                  } else {
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
            MaterialPageRoute(builder: (context) => ChatScreen(widget.cloneNameFromFirestore, widget.userName)));
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
                              widget.cloneNameFromFirestore,
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