import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../widgets/chat_widget.dart';

class DetailOfHistory extends StatelessWidget {
  final List<ChatModel> chatList;

  const DetailOfHistory({Key? key, required this.chatList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Old Chat'),
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          return ChatWidget(
            msg: chatList[index].msg,
            chatIndex: chatList[index].chatIndex,
            shouldAnimate: chatList.length - 1 == index,
          );
        },
      ),
    );
  }
}
