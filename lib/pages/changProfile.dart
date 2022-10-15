import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_network_1/pages/chat_part/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

class ChangProfile extends StatefulWidget {
  const ChangProfile({Key? key}) : super(key: key);

  @override
  State<ChangProfile> createState() => _ChangProfileState();
}

class _ChangProfileState extends State<ChangProfile> {
  String downloadURL = "";
  bool uplodeProfile = false;

  uplodeImage() async {
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();

    PickedFile? image;

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      image = await picker.getImage(source: ImageSource.gallery);

      if (image != null) {
        var file = File(image.path);

        var snapshot = await storage
            .ref()
            .child("Profile/${userinfo.username}ProfilePic")
            .putFile(file);

        downloadURL = await snapshot.ref.getDownloadURL();
        userinfo.userProfile = downloadURL;
        uplodeProfile = true;
        setState(() {});
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          80.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  ImageInChat.sender = userinfo.username;
                  ImageInChat.src = userinfo.userProfile;
                  await Navigator.pushNamed(
                      context, MyRoultes.imageViewer_roultr);
                },
                child: downloadURL == ""
                    ? Image.network(
                        userinfo.userProfile,
                        height: 50,
                        width: 50,
                      )
                    : Image.network(
                        downloadURL,
                        height: 50,
                        width: 50,
                      ),
              ),
              50.widthBox,
              TextButton(
                  onPressed: uplodeImage,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25)),
                      color: Color.fromARGB(255, 154, 197, 230),
                    ),
                    // width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Change Profile",
                            style: TextStyle(fontSize: 20),
                          ).px12().py12(),
                        ]),
                  ))
            ],
          ),
          50.heightBox,
          uplodeProfile
              ? TextButton(
                  onPressed: () async {
                    var database = FirebaseDatabase.instance.reference();

                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('Profile/${userinfo.username}ProfilePic');

                    var url = await ref.getDownloadURL();

                    database
                        .child("User/${userinfo.username}/")
                        .update({"Profile": url});
                    await Navigator.pushNamed(context, MyRoultes.home_roultr);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25)),
                      color: Color.fromARGB(255, 154, 197, 230),
                    ),
                    // width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Done",
                            style: TextStyle(fontSize: 20),
                          ).px12().py12(),
                        ]),
                  ))
              : Container()
        ],
      ),
      appBar: AppBar(
        title: "Profile".text.make(),
        backgroundColor: context.theme.primaryColor,
      ),
    ));
  }
}
