import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/Models/chat_model.dart';
import 'package:flash_chat/Models/themes.dart';
import 'package:flash_chat/firebase_options.dart';
import 'package:flash_chat/providers/delete_clone_provider.dart';
import 'package:flash_chat/providers/user_name_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'UI/flash_chatUI.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MultiProvider( providers: [
    ChangeNotifierProvider(create: (context)=> ChatProvider()),
    ChangeNotifierProvider(create: (context)=> DeleteCloneProvider()),
    ChangeNotifierProvider(create: (context)=> UserNameProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(375, 675),
      builder: (context,_){
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,
          theme: lightTheme,
          home: const FlashChat(),
        );
      },
    );
  }
}
