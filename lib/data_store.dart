import 'package:flutter_application_network_1/utils/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkLogin() async {
  bool cl = false;
  final prefs = await SharedPreferences.getInstance();
  String? un = prefs.getString("userName");
  String? up = prefs.getString("userProfile");

  if (un == null) {
    cl = false;
  } else {
    userinfo.username = un;
    userinfo.userProfile = up!;
    cl = true;
  }
  // await Future.delayed(const Duration(seconds: 3)); //seconds 1

  print("username at checkLogin :- ${userinfo.username}");
  // return cl;
}

Future<void> setLogin(String un, String up) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("userName", un);
  await prefs.setString("userProfile", up);
}

Future<void> setLogout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("userName");
  await prefs.remove("userProfile");
}
