import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_network_1/data_store.dart';
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
  String tempprofile = userinfo.userProfile;
  bool uplodeProfile = false;
  bool deleteProfile = false;

  uplodeImage() async {
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    var database = FirebaseDatabase.instance.reference();

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
        tempprofile = downloadURL;
        uplodeProfile = true;
        setState(() {});
      }
    } else {}
  }

  deleteImage() async {
    tempprofile =
        "https://firebasestorage.googleapis.com/v0/b/first-network-e3fc6.appspot.com/o/Profile%2Fblank-profile.png?alt=media&token=e5bb7c34-f2c7-4b8d-a226-62c357d9ad55";
    uplodeProfile = true;
    deleteProfile = true;
    // print("delete");
    setState(() {});
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
                  ImageInChat.src = tempprofile;
                  await Navigator.pushNamed(
                      context, MyRoultes.imageViewer_roultr);
                },
                child: downloadURL == ""
                    ? Image.network(
                        tempprofile,
                        height: 75,
                        width: 75,
                      )
                    : Image.network(
                        downloadURL,
                        height: 75,
                        width: 75,
                      ),
              ),
              50.widthBox,
              Column(
                children: [
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
                      )),
                  TextButton(
                      onPressed: deleteImage,
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
                                "Delete Profile",
                                style: TextStyle(fontSize: 20),
                              ).px12().py12(),
                            ]),
                      ))
                ],
              )
            ],
          ),
          50.heightBox,
          uplodeProfile
              ? TextButton(
                  onPressed: () async {
                    var database = FirebaseDatabase.instance.reference();
                    if (deleteProfile) {
                      database.child("User/${userinfo.username}/").update({
                        "Profile":
                            "https://firebasestorage.googleapis.com/v0/b/first-network-e3fc6.appspot.com/o/Profile%2Fblank-profile.png?alt=media&token=e5bb7c34-f2c7-4b8d-a226-62c357d9ad55"
                      });
                    } else {
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child('Profile/${userinfo.username}ProfilePic');

                      var url = await ref.getDownloadURL();

                      database
                          .child("User/${userinfo.username}/")
                          .update({"Profile": url});
                    }

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
              : TextButton(
                  onPressed: () async {
                    setLogout();

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
                            "Log Oute",
                            style: TextStyle(fontSize: 20),
                          ).px12().py12(),
                        ]),
                  ))
        ],
      ),
      appBar: AppBar(
        title: "Profile".text.make(),
        backgroundColor: context.theme.primaryColor,
      ),
    ));
  }
}
