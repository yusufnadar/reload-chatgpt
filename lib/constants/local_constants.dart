// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';
import '../providers/chats_provider.dart';

class LocalService {
  static final getStorage = GetStorage();

  static Future<void> write(
      List<ChatModel> listNeedToSave, BuildContext context) async {
    if (listNeedToSave.isEmpty) {
      return;
    }
    var chatList = [];
    for (var item in listNeedToSave) {
      chatList.add(
        ChatModel(msg: item.msg, chatIndex: item.chatIndex).toJson(),
      );
    }
    await getStorage.write(listNeedToSave.first.msg.split(' ').first, chatList);
    Provider.of<ChatProvider>(context, listen: false).clearChatList();
  }

  static List<String> read() {
    return List<String>.from(getStorage.getKeys());
  }

  static List<ChatModel> getHistory(String key) {
    List<dynamic> value = getStorage.read(key);
    return List<ChatModel>.from(
      value.map((e) => ChatModel.fromJson(e)),
    );
  }
}
