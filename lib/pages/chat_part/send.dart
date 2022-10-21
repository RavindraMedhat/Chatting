import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/utils/message.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Send extends StatelessWidget {
  Send({Key? key}) : super(key: key);
  final TextEditingController msgtext = TextEditingController();

  sendImage(String byWhat) async {
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();

    PickedFile? image;

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      image = await picker.getImage(
          source:
              byWhat == "gallery" ? ImageSource.gallery : ImageSource.camera);

      if (image != null) {
        var file = File(image.path);

        var snapshot = await storage
            .ref()
            .child(
                "ChatGroup/${userinfo.chatgroup}/${userinfo.username} ${DateTime.now().toString()}")
            .putFile(file);

        var downloadURL = await snapshot.ref.getDownloadURL();

        final database = FirebaseDatabase.instance.ref();

        await database.child("ChatGroup/${userinfo.chatgroup}/").push().set({
          "ID": DateTime.now().toString(),
          "Time": DateFormat("HH:mm:ss").format(DateTime.now()).toString(),
          "Date": DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
          "Sender": userinfo.username,
          "ContentType": "Image",
          "Content": downloadURL
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLines: null,
        onChanged: (value) {
          if (msgtext.text == " ") {
            msgtext.text = "";
          }
        },
        style: const TextStyle(fontSize: 25),
        controller: msgtext,
        decoration: InputDecoration(
          fillColor: Colors.blue,
          focusColor: Colors.blue,
          hintText: "Message",
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
            mainAxisSize: MainAxisSize.min, // added line

            children: [
              Material(
                child: InkWell(
                  onTap: () => sendImage("gallery"),
                  onLongPress: () => sendImage("camera"),
                  child: Ink(
                    child: Icon(
                      Icons.image,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
                onPressed: () async {
                  if (msgtext.text != "") {
                    final database = FirebaseDatabase.instance.ref();
                    await database
                        .child("ChatGroup/${userinfo.chatgroup}/")
                        .push()
                        .set({
                      "ID": DateTime.now().toString(),
                      "Time": DateFormat("HH:mm:ss")
                          .format(DateTime.now())
                          .toString(),
                      "Date": DateFormat("dd-MM-yyyy")
                          .format(DateTime.now())
                          .toString(),
                      "Sender": userinfo.username,
                      "ContentType": "Text",
                      "Content": msgtext.text
                    });
                    msgtext.text = "";
                  }
                },
              ),
            ],
          ),
        ));
  }
}
