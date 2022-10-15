import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/pages/chat_part/ChatMessage.dart';
import 'package:flutter_application_network_1/pages/chat_part/send.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_application_network_1/pages/chat_part/message.dart';

import '../utils/roultes.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            children: [
              InkWell(
                onTap: () async {
                  ImageInChat.sender = userinfo.chatwith;
                  ImageInChat.src = userinfo.chatwithProfile;
                  await Navigator.pushNamed(
                      context, MyRoultes.imageViewer_roultr);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(userinfo.chatwithProfile),
                        fit: BoxFit.fill),
                  ),
                ).pOnly(right: 16),
              ),
              userinfo.chatwith.text.color(Colors.white).make(),
            ],
          ),
        ),
        body: finalChat().h(8000),
        bottomSheet: Send().pOnly(left: 6),
      ),
    ).backgroundColor(Colors.white);
  }
}
