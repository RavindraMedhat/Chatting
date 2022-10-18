import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_network_1/pages/chat_part/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
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
              downloadURL == ""
                  ? Image.asset(
                      'assets/images/blank-profile.png',
                      height: 50,
                      width: 50,
                    )
                  : Image.network(
                      downloadURL,
                      height: 50,
                      width: 50,
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
                            "Uplode Profile",
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
                    database.child("User/").update({
                      userinfo.username: {"Password": userinfo.password}
                    });
                    await Future.delayed(const Duration(seconds: 1));

                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('Profile/${userinfo.username}ProfilePic');
                    var url = await ref.getDownloadURL();

                    database
                        .child("User/${userinfo.username}/")
                        .update({"Profile": url});
                    userinfo.username = "";
                    await Navigator.pushNamed(context, MyRoultes.login_roultr);
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
