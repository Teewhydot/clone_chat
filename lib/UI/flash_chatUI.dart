
// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Models/conversation_list_ui.dart';
import 'package:flash_chat/Models/constants.dart';
import 'package:flash_chat/UI/add-new-clone-screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FlashChat extends StatefulWidget {
 final String userName;

  const FlashChat({super.key, required this.userName});

  @override
  State<FlashChat> createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {
  Map<String, dynamic> data = {};

  static List<ConversationList> conversationList = [];

  List<ConversationList> displayList = List.from(conversationList);
  final fireStore = FirebaseFirestore.instance;

  Color? newCloneColor;
  var newUserName;
  late Stream<QuerySnapshot> cloneStream;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cloneStream = fireStore
        .collection(widget.userName)
        .doc(widget.userName)
        .collection('clones')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    void awaitCloneNameFromModalPopup(BuildContext context) async {
      // start the SecondScreen and wait for it to finish with a result
      final result = await showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => const AddNewUserClone());

      // after the SecondScreen result comes back update the Text widget with it
      setState(() {
        newCloneColor = result;
      });
    }

    Widget buildAlertDialog(BuildContext context) {
      return AlertDialog(
        title: const Text('FYI'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Clones + Chats = Clats'),
            addVerticalSpacing(5),
            const Text('Tap and hold on a clone to delete it'),
          ],
        ),
        actions: [
          SizedBox(
              width: 75.w,
              height: 35.h,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.blue),
                  )))
        ],
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_circle_outlined),
          onPressed: () {
            awaitCloneNameFromModalPopup(context);
          }),
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
                  colors: [Color(0xff903aff), Color(0xffdf44ff)])),
        ),
        centerTitle: true,
        elevation: 0,
        title: const Text('Clone-Chat'),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(5.0.r),
              child: Row(
                children: [
                  Text(
                    'Clats',
                    style: TextStyle(
                      fontSize: 24.sp,
                    ),
                  ),
                  addHorizontalSpacing(10),
                  GestureDetector(
                      onTap: () {
                        showDialog(context: context, builder: buildAlertDialog);
                      },
                      child: const Icon(Icons.info)),
                ],
              ),
            ),
          ),
          addVerticalSpacing(10),
          const Text('Tap the + button below to create a new ShadowClone'),
          addVerticalSpacing(10),
          Expanded(
            flex: 15,
            child: StreamBuilder<QuerySnapshot>(
                stream: cloneStream,
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
                      return ConversationList(data['cloneName'],widget.userName,newCloneColor);
                    }).toList(),
                  );
                }),
          )
        ],
      ),
    );
  }
}
