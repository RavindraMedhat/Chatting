import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/utils/message.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // closeApp(context);
    return SafeArea(
        child: Scaffold(
      body: AlertDialog(
        title: Text("Confirm exit"),
        content: Text("Do you want to quit the Chatting ?"),
        actions: [
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.pushNamed(context, pageHistory.lastPage);
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      ),
      // body: closeApp(context),
    ));
  }
}
