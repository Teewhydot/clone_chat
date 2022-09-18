import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Functions/firebase_functions.dart';
import 'package:flash_chat/Models/constants.dart';
import 'package:flash_chat/UI/chat-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:progress_indicator_button/progress_button.dart';
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
  final color = avatarColor();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    Widget buildAlertDialog(BuildContext context) {
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
              child: ProgressButton(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                onPressed: (AnimationController controller) {
                  Navigator.pop(context);
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          SizedBox(
            width: 75.w,
            height: 25.h,
            child: ProgressButton(
              progressIndicatorSize: 10.sp,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              strokeWidth: 2,
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (AnimationController controller) async {
                if (controller.isCompleted) {
                  controller.reverse();
                } else {

                  hasInternet = await InternetConnectionChecker().hasConnection;
                  if (hasInternet) {
                    controller.forward();
                    await deleteClone(widget.name);
                    nav.pop();
                    Toast.show("Clone deleted",
                        duration: Toast.lengthShort,
                        gravity: Toast.center,
                        backgroundColor: Colors.amberAccent.shade700);
                  } else {
                    Toast.show("No internet connection",
                        duration: Toast.lengthShort,
                        gravity: Toast.center,
                        backgroundColor: Colors.amberAccent.shade700);
                  }
                }
              },
            ),
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
