import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_network_1/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  String downloadURL = "";
  bool uplodeProfile = false;

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

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

  skip() async {
    uplodeProfile = true;

    var database = FirebaseDatabase.instance.reference();
    database.child("User/").update({
      userinfo.username: {"Password": userinfo.password}
    });
    database.child("User/${userinfo.username}/").update({
      "Profile":
          "https://firebasestorage.googleapis.com/v0/b/first-network-e3fc6.appspot.com/o/Profile%2Fblank-profile.png?alt=media&token=e5bb7c34-f2c7-4b8d-a226-62c357d9ad55"
    });
    await Future.delayed(const Duration(seconds: 1));

    userinfo.username = "";
    await Navigator.pushNamed(context, MyRoultes.login_roultr);
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
              downloadURL == ""
                  ? Image.asset(
                      'assets/images/blank-profile.png',
                      height: 75,
                      width: 75,
                    )
                  : Image.network(
                      downloadURL,
                      height: 75,
                      width: 75,
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
                                "Uplode Profile",
                                style: TextStyle(fontSize: 20),
                              ).px12().py12(),
                            ]),
                      )),
                  TextButton(
                      onPressed: skip,
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
                                "skip for now",
                                style: TextStyle(fontSize: 20),
                              ).px12().py12(),
                            ]),
                      )),
                ],
              )
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
