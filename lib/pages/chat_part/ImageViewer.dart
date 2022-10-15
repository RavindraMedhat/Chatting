import 'package:flutter/material.dart';
import 'package:flutter_application_network_1/pages/chat_part/ChatMessage.dart';
import 'package:flutter_application_network_1/pages/chat_part/send.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_application_network_1/pages/chat_part/message.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key? key}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
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
          title: ImageInChat.sender.text.make(),
        ),
        body: Center(
            child: InteractiveViewer(
                panEnabled: false,
                minScale: 1,
                maxScale: 20,
                child: Image.network(ImageInChat.src))),
      ),
    ).backgroundColor(Colors.white);
  }
}
