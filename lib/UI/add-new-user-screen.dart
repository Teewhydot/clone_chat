import 'package:flash_chat/Functions/firebase_functions.dart';
import 'package:flash_chat/Models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewUserScreen extends StatefulWidget {
  const AddNewUserScreen({Key? key}) : super(key: key);

  @override
  State<AddNewUserScreen> createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    bool hasInternet;

    final nav = Navigator.of(context);
    final fireStore = FirebaseFirestore.instance;
    ToastContext().init(context);
    final TextEditingController cloneNameController = TextEditingController();

    Future<bool> checkExist(String docID) async {
      bool exist = false;

      await fireStore
          .collection('clones')
          .doc(docID)
          .get()
          .then((value) => exist = value.exists);
      return exist;
    }

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
                    hasInternet =
                        await InternetConnectionChecker().hasConnection;
                    if (cloneNameController.text.isEmpty) {
                      Toast.show("Type in a valid name",
                          duration: Toast.lengthShort,
                          gravity: Toast.center,
                          backgroundColor: Colors.amberAccent.shade700);
                    } else if (hasInternet == false) {
                      Toast.show("No internet connection",
                          duration: Toast.lengthShort,
                          gravity: Toast.center,
                          backgroundColor: Colors.amberAccent.shade700);
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      bool cloneExists =
                          await checkExist(cloneNameController.text.trim());
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
                            .collection('clones')
                            .doc(cloneNameController.text)
                            .set({
                          'cloneName': cloneNameController.text,
                        });
                        addCloneToFirebase(cloneNameController.text);

                        cloneNameController.clear();
                        setState(() {
                          isLoading = false;
                        });
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
                            addHorizontalSpacing(5),
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
