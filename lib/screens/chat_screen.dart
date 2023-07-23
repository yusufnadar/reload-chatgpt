import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../constants/color_constants.dart';
import '../constants/image_constants.dart';
import '../mixins/bottom_sheet.dart';
import '../providers/chats_provider.dart';
import '../providers/models_provider.dart';
import '../widgets/chat_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with CustomSheet {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const Drawer(),
      body: SafeArea(
        child: Column(
          children: [
            buildMessages(chatProvider),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: ColorConstants.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    buildTextInput(modelsProvider, chatProvider),
                    buildSendIcon(modelsProvider, chatProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Flexible buildMessages(ChatProvider chatProvider) {
    return Flexible(
      child: ListView.builder(
        controller: _listScrollController,
        itemCount: chatProvider.chatList.length,
        itemBuilder: (context, index) {
          return ChatWidget(
            msg: chatProvider.chatList[index].msg,
            chatIndex: chatProvider.chatList[index].chatIndex,
            shouldAnimate: chatProvider.chatList.length - 1 == index,
          );
        },
      ),
    );
  }

  Expanded buildTextInput(
      ModelsProvider modelsProvider, ChatProvider chatProvider) {
    return Expanded(
      child: TextField(
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white),
        controller: textEditingController,
        onSubmitted: (value) async {
          await sendMessageFCT(
            modelsProvider: modelsProvider,
            chatProvider: chatProvider,
          );
        },
        decoration: const InputDecoration.collapsed(
          hintText: "How can I help you",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  IconButton buildSendIcon(
      ModelsProvider modelsProvider, ChatProvider chatProvider) {
    return IconButton(
      onPressed: () async {
        await sendMessageFCT(
          modelsProvider: modelsProvider,
          chatProvider: chatProvider,
        );
      },
      icon: const Icon(
        Icons.send,
        color: Colors.white,
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(
        () {
          _isTyping = true;
          chatProvider.addUserMessage(msg: msg);
          textEditingController.clear();
          focusNode.unfocus();
        },
      );
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(
        () {
          scrollListToEND();
          _isTyping = false;
        },
      );
    }
  }
}
