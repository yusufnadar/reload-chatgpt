import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> _chatList = [];

  List<ChatModel> get chatList => _chatList;

  set chatList(list) => _chatList = list;

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(
        await ApiService.sendMessageGPT(
          message: msg,
          modelId: chosenModelId,
        ),
      );
    } else {
      chatList.addAll(
        await ApiService.sendMessage(
          message: msg,
          modelId: chosenModelId,
        ),
      );
    }
    notifyListeners();
  }

  void clearChatList() {
    chatList.clear();
    notifyListeners();
  }
}
