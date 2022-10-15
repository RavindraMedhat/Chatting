import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/pages/AddProfilepage.dart';
import 'package:flutter_application_network_1/pages/Chat_page.dart';
import 'package:flutter_application_network_1/pages/Home_page.dart';
import 'package:flutter_application_network_1/pages/changProfile.dart';
import 'package:flutter_application_network_1/pages/chat_part/ImageViewer.dart';
import 'package:flutter_application_network_1/pages/log_in_page.dart';
import 'package:flutter_application_network_1/pages/singUp_page.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';
import 'package:flutter_application_network_1/utils/themes.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: HomePage(),
      themeMode: ThemeMode.system,
      theme: MyTheme.lightThem(context),
      darkTheme: MyTheme.darkThem(context),
      debugShowCheckedModeBanner: false,
      // initialRoute: MyRoultes.home_roultr,
      routes: {
        "/": (context) => const LoginPage(),
        MyRoultes.home_roultr: (context) => Home(),
        MyRoultes.addProfile_roultr: (context) => const AddProfile(),
        MyRoultes.changProfile_roultr: (context) => const ChangProfile(),
        MyRoultes.chat_roultr: (context) => const Chat(),
        MyRoultes.imageViewer_roultr: (context) => const ImageViewer(),
        MyRoultes.login_roultr: (context) => const LoginPage(),
        MyRoultes.singUp_roultr: (context) => const SingUpPage(),
      },
    );
  }
}
