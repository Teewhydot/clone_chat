// ignore_for_file: use_build_context_synchronously

import 'package:flash_chat/Functions/firebase_functions.dart';
import 'package:flash_chat/Models/constants.dart';
import 'package:flash_chat/providers/user_name_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewUserClone extends StatefulWidget {
  const AddNewUserClone({Key? key}) : super(key: key);

  @override
  State<AddNewUserClone> createState() => _AddNewUserCloneState();
}

class _AddNewUserCloneState extends State<AddNewUserClone> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    bool hasInternet;
    final provider = Provider.of<UserNameProvider>(context);
    final nav = Navigator.of(context);
    final fireStore = FirebaseFirestore.instance;
    ToastContext().init(context);
    final TextEditingController cloneNameController = TextEditingController();


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color(0xff757575),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r))),
          child: Column(
            children: [
              addVerticalSpacing(10),
              Text(
                'Create a new clone',
                style: TextStyle(
                  fontSize: 20.sp,
                ),
              ),
              addVerticalSpacing(20),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: TextField(
                  controller: cloneNameController,
                  cursorColor: Colors.black,
                  minLines: 1,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff759090),
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0,
                          style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    hintText: "Enter your clones' name",
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0.h, horizontal: 20.0.w),
                  ),
                ),
              ),
              addVerticalSpacing(10),
              SizedBox(
                width: 150.w,
                height: 30.h,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    hasInternet =
                        await InternetConnectionChecker().hasConnection;
                    if (cloneNameController.text.isEmpty) {
                      Toast.show("Type in a valid name",
                          duration: Toast.lengthShort,
                          gravity: Toast.center,
                          backgroundColor: Colors.amberAccent.shade700);
                      setState(() {
                        isLoading = false;
                      });
                    } else if (hasInternet == false) {
                      Toast.show("No internet connection",
                          duration: Toast.lengthShort,
                          gravity: Toast.center,
                          backgroundColor: Colors.amberAccent.shade700);
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      bool cloneExists =
                          await checkExist(cloneNameController.text.trim(),context);
                      if (cloneExists) {
                        Toast.show("Clone already exists",
                            backgroundColor: Colors.amberAccent.shade700,
                            duration: Toast.lengthShort,
                            gravity: Toast.center);
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        await fireStore
                            .collection(provider.name)
                            .doc(provider.name)
                            .collection('clones')
                            .doc(cloneNameController.text)
                            .set({
                          'cloneName': cloneNameController.text,
                        });

                        await fireStore
                            .collection(provider.name)
                            .doc(provider.name)
                            .collection('clones')
                            .doc(cloneNameController.text)
                            .collection('chats')
                            .add({
                          'messageText':
                              'Hello, I am your new clone ${cloneNameController.text}, Tap the switch on the top right corner of your screen to switch places with me.',
                          'whoSent': 'receiver',
                          'time': DateTime.now(),
                        });
                        cloneNameController.clear();
                        setState(() {
                          isLoading = false;
                        });
                        //call the function to return a random color for the circle avatar of the newly created clone
                        nav.pop();
                        Toast.show('Clone created successfully',
                            duration: Toast.lengthShort,
                            backgroundColor: const Color(0xff903aff),
                            gravity: Toast.center);
                      }
                    }
                  },
                  child: isLoading
                      ? Row(
                          children: [
                            const LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [Colors.white],
                                strokeWidth: 2,
                                backgroundColor: Colors.transparent,
                                pathBackgroundColor: Colors.transparent),
                            addHorizontalSpacing(10),
                            const Text('Please wait'),
                          ],
                        )
                      : const Text('Create Clone'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
