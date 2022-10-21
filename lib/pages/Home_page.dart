import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/utils/message.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatelessWidget {
  final database = FirebaseDatabase.instance.ref();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // userinfo.username = "Ravindrasinh";

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: context.theme.primaryColor,
              title: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      ImageInChat.sender = userinfo.username;
                      ImageInChat.src = userinfo.userProfile;
                      await Navigator.pushNamed(
                          context, MyRoultes.imageViewer_roultr);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            // image: AssetImage(
                            //     'assets/images/blank-profile.png'),
                            image: NetworkImage(userinfo.userProfile),
                            fit: BoxFit.fill),
                      ),
                    ).p(40),
                  ),
                  userinfo.username.text.make(),
                ],
              ),
              actions: [
                IconButton(
                    tooltip: "Change Profile",
                    onPressed: () async {
                      await Navigator.pushNamed(
                          context, MyRoultes.changProfile_roultr);
                    },
                    icon: const Icon(
                      CupertinoIcons.profile_circled,
                      size: 35,
                    ))
              ],
            ),
            body: Scrollbar(
              thumbVisibility: true,
              radius: Radius.circular(5),
              thickness: 8,
              interactive: true,
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: database.child("User/").limitToLast(10000).onValue,
                  builder: (context, snapshot) {
                    final userList = <String>[];
                    final userProfileList = <String>[];
                    final tilesList = <Container>[];

                    if (snapshot.hasData) {
                      final user = Map<String, dynamic>.from(
                          (newMethod(snapshot).snapshot.value as dynamic));

                      user.forEach((key, value) {
                        userList.add(key.toString());
                        if (value["Profile"] == null) {
                          userProfileList.add("");
                        } else {
                          userProfileList.add(value["Profile"]);
                          // userProfileList.add(""); //remove after
                        }
                      });

                      // userList.sort((a, b) => a.compareTo(b));

                      for (var i = 0; i < userList.length; i++) {
                        if (userList[i] != userinfo.username) {
                          final nextuser = userList[i];

                          // var ref = FirebaseStorage.instance
                          //     .ref()
                          //     .child('Profile/${nextuser[i]}ProfilrPic');
                          // var url =  ref.getDownloadURL();

                          final userTitle = Container(
                              child: TextButton(
                                  onPressed: () async {
                                    userinfo.chatwith = userList[i];
                                    userinfo.chatwithProfile =
                                        userProfileList[i];
                                    userinfo.chatgrouplist
                                        .add(userinfo.username);
                                    userinfo.chatgrouplist
                                        .add(userinfo.chatwith);
                                    userinfo.chatgrouplist.sort(
                                      (a, b) =>
                                          a.toString().compareTo(b.toString()),
                                    );
                                    userinfo.chatgroup =
                                        userinfo.chatgrouplist[0] +
                                            userinfo.chatgrouplist[1];

                                    await Navigator.pushNamed(
                                        context, MyRoultes.chat_roultr);

                                    userinfo.chatgrouplist = [];
                                    userinfo.chatgroup = "";
                                    userinfo.chatwith = "";
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
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          20.widthBox,
                                          userProfileList[i] == ""
                                              ? Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/blank-profile.png'),
                                                        fit: BoxFit.fill),
                                                  ),
                                                ).p(2)
                                              : InkWell(
                                                  onTap: () async {
                                                    ImageInChat.sender =
                                                        nextuser;
                                                    ImageInChat.src =
                                                        userProfileList[i];
                                                    await Navigator.pushNamed(
                                                        context,
                                                        MyRoultes
                                                            .imageViewer_roultr);
                                                  },
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          // image: AssetImage(
                                                          //     'assets/images/blank-profile.png'),
                                                          image: NetworkImage(
                                                              userProfileList[
                                                                  i]),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ).px12(),
                                                ),
                                          Text(
                                            nextuser,
                                            style: TextStyle(fontSize: 30),
                                          ).px32(),
                                        ]),
                                  ).wFull(context).px16()));
                          tilesList.add(userTitle);
                        }
                      }
                    }
                    return Column(
                      children: tilesList,
                    );
                  },
                ),
              ),
            )));
  }

  DatabaseEvent newMethod(AsyncSnapshot<Object?> snapshot) =>
      snapshot.data! as DatabaseEvent;
}
