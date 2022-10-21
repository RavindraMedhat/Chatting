// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';
import 'package:flutter_application_network_1/utils/themes.dart';
import 'package:get/get.dart';

// Future<void> closeApp(BuildContext context) async {}
closeApp(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    // barrierColor: Color.fromARGB(1, 1, 1, 1),
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm exit"),
        content: Text("Do you want to quit the Chatting ?"),
        actions: [
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      );
    },
  );
}

class pageHistory {
  static String lastPage = "";
}

class ImageInChat {
  static String src = "";
  static String sender = "";
}

class userinfo {
  static List chatgrouplist = [];
  static String chatgroup = "";
  static String chatwith = "";
  static String chatwithProfile = "";
  static String username = "";
  static String userProfile = "";
  static String password = "";
}

class Message {
  String ID;
  String Time;
  String Date;
  String Sender;
  String ContentType;
  String Content;

  Message(
      {required this.ID,
      required this.Time,
      required this.Date,
      required this.Sender,
      required this.ContentType,
      required this.Content});

  factory Message.formOBJ(data) {
    return Message(
        ID: data["ID"],
        Time: data["Time"],
        Date: data["Date"],
        Sender: data["Sender"],
        ContentType: data["ContentType"],
        Content: data["Content"]);
  }

  String factoryDes() {
    return '$Sender send message :- $Content at $Time on $Date';
  }
}

class Notification {
  String ID;
  String Time;
  String Date;
  String Sender;
  String ContentType;
  String Content;

  Notification(
      {required this.ID,
      required this.Time,
      required this.Date,
      required this.Sender,
      required this.ContentType,
      required this.Content});

  factory Notification.formOBJ(data) {
    return Notification(
        ID: data["ID"],
        Time: data["Time"],
        Date: data["Date"],
        Sender: data["Sender"],
        ContentType: data["ContentType"],
        Content: data["Content"]);
  }

  String factoryDes() {
    return '$Sender send message :- $Content at $Time on $Date';
  }
}
