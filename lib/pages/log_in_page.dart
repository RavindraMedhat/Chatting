import 'dart:io';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/data_store.dart';
import 'package:flutter_application_network_1/utils/message.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // String name = "";

  bool changebutton = false;
  final _formKey = GlobalKey<FormState>();
  static String pass = "";
  final TextEditingController loginform_password = TextEditingController();
  final TextEditingController loginform_username = TextEditingController();

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changebutton = true;
      });
      await Future.delayed(const Duration(seconds: 1)); //seconds 1
      // ignore: use_build_context_synchronously
      // print("first object");

      setLogin(userinfo.username, userinfo.userProfile);

      await Navigator.pushNamed(context, MyRoultes.home_roultr);
      // closeApp(context);
      pageHistory.lastPage = MyRoultes.home_roultr;
      await Navigator.pushNamed(context, MyRoultes.AlertDialogBack_roult);

      userinfo.chatgrouplist = [];
      userinfo.chatgroup = "";
      userinfo.username = "";
      userinfo.password = "";

      setState(() {
        userinfo.username = "";
        changebutton = false;
        loginform_password.clear();
        loginform_username.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                'assets/images/hey.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Welcome ${userinfo.username}",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Column(
                  children: [
                    TextFormField(
                      controller: loginform_username,
                      decoration: const InputDecoration(
                          hintText: "Enter User Name", labelText: "User Name"),
                      validator: (value) {
                        print("paswor :- $pass");
                        sleep(const Duration(seconds: 1));
                        if (value!.isEmpty) {
                          return "Usrename can not be empty";
                        } else if (pass == "null") {
                          return "User name not mach";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        userinfo.username = value;
                        final database = FirebaseDatabase.instance.ref();
                        database
                            .child("User/")
                            .child("$value/Password/")
                            .onValue
                            .listen((event) {
                          pass = event.snapshot.value.toString();
                        });
                        database
                            .child("User/")
                            .child("$value/Profile/")
                            .onValue
                            .listen((event) {
                          userinfo.userProfile =
                              event.snapshot.value.toString();
                        });
                        setState(() {});
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: loginform_password,
                      decoration: const InputDecoration(
                          hintText: "Enter Password", labelText: "Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          pass = "";
                          return "password can not be empty";
                        } else if (value != pass) {
                          pass = "";
                          // print("pass :-" + pass);
                          return "Enter corect password";
                        }
                        pass = "";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: () => moveToHome(context),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 5),
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    child: changebutton
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                  ),
                ),
              ),
              20.heightBox,
              Material(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, MyRoultes.singUp_roultr),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 5),
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    child: const Text(
                      "Sing Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Image.asset("assets/images/login_image.png")