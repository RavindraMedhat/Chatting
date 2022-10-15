import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_network_1/pages/chat_part/message.dart';
import 'package:flutter_application_network_1/utils/roultes.dart';
import 'package:velocity_x/velocity_x.dart';

class finalChat extends StatelessWidget {
  final database = FirebaseDatabase.instance.ref();

  finalChat({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://cdn.wallpapersafari.com/4/11/WofyVJ.png"),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            reverse: true,
            controller: _scrollController,
            child: StreamBuilder(
              stream: database
                  .child("ChatGroup/${userinfo.chatgroup}/")
                  .limitToLast(10000)
                  .onValue,
              builder: (context, snapshot) {
                final msgOBJList = <Message>[];
                final tilesList = <Container>[];

                if (snapshot.hasData &&
                    (newMethod(snapshot).snapshot.value) != null) {
                  final myMessage = Map<String, dynamic>.from(
                      ((newMethod(snapshot).snapshot.value) as dynamic));

                  myMessage.forEach((key, value) {
                    final nextMessage = Map<String, dynamic>.from(value);
                    final Message msg = Message(
                        ID: nextMessage["ID"],
                        Time: nextMessage["Time"],
                        Date: nextMessage["Date"],
                        Sender: nextMessage["Sender"],
                        Content: nextMessage["Content"],
                        ContentType: nextMessage["ContentType"]);
                    msgOBJList.add(msg);
                  });

                  msgOBJList.sort((a, b) {
                    return a.ID.compareTo(b.ID);
                  });

                  for (var i = 0; i < msgOBJList.length; i++) {
                    // final nextMessage = msgOBJList[i] as Object;

                    final nextMessage = msgOBJList[i];

                    double r = nextMessage.Sender == userinfo.username ? 0 : 40;
                    double l = nextMessage.Sender == userinfo.username ? 40 : 0;

                    final messageTitle = Container(
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(
                        onLongPress: () {
                          Clipboard.setData(
                              ClipboardData(text: nextMessage.Content));
                        },

                        onTap: () async {
                          if (nextMessage.ContentType == "Image") {
                            ImageInChat.sender = nextMessage.Sender;
                            ImageInChat.src = nextMessage.Content;
                            await Navigator.pushNamed(
                                context, MyRoultes.imageViewer_roultr);
                          }
                        },
                        
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(r),
                                bottomRight: Radius.circular(r),
                                topLeft: Radius.circular(l),
                                bottomLeft: Radius.circular(l)),
                            color: Color.fromARGB(255, 154, 197, 230),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                              crossAxisAlignment:
                                  nextMessage.Sender == userinfo.username
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(r),
                                        bottomRight: Radius.circular(r),
                                        topLeft: Radius.circular(l),
                                        bottomLeft: Radius.circular(l)),
                                    color: Colors.black26,
                                  ),
                                  child: Text(
                                    nextMessage.Sender,
                                    textAlign:
                                        nextMessage.Sender == userinfo.username
                                            ? TextAlign.right
                                            : TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ).px4().px2(),
                                ).w32(context),
                                nextMessage.ContentType == "Image"
                                    ? Image.network(nextMessage.Content).p8()
                                    : Text(
                                        nextMessage.Content,
                                        style: const TextStyle(fontSize: 20),
                                      ).px12(),
                                Text(
                                  "${nextMessage.Date}  ${nextMessage.Time}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                                ).p8(),
                              ]),
                        ).pOnly(
                            left: nextMessage.Sender == userinfo.username
                                ? MediaQuery.of(context).size.width / 3
                                : 0,
                            right: nextMessage.Sender == userinfo.username
                                ? 0
                                : MediaQuery.of(context).size.width / 3,
                            top: 10),
                      ),
                    );
                    tilesList.add(messageTitle);
                  }
                }
                return Column(
                  children: tilesList,
                );
              },
            ),
          )
          // ],
          // ),
          //
          ).wFull(context).pOnly(bottom: 50),
    );
  }

  DatabaseEvent newMethod(AsyncSnapshot<Object?> snapshot) =>
      snapshot.data! as DatabaseEvent;
}
