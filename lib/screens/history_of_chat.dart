import 'package:chatgpt_course/constants/local_constants.dart';
import 'package:flutter/material.dart';

import 'detail_of_history.dart';

class HistoryOfChat extends StatelessWidget {
  final List<String> chats;

  const HistoryOfChat({Key? key, required this.chats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Histories'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              chats[index],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              var list = LocalService.getHistory(chats[index]);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailOfHistory(
                    chatList: list,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
