import 'package:chatgpt_course/screens/detail_of_history.dart';
import 'package:chatgpt_course/screens/history_of_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/image_constants.dart';
import '../constants/local_constants.dart';
import '../mixins/bottom_sheet.dart';
import '../providers/chats_provider.dart';

class CustomAppBar extends StatelessWidget
    with CustomSheet
    implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return AppBar(
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(ImageConstants.openaiLogo),
      ),
      title: const Text("ChatGPT"),
      actions: [
        IconButton(
          onPressed: () {
            List<String> list = LocalService.read();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HistoryOfChat(chats: list),
              ),
            );

          },
          icon: const Icon(
            Icons.list,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () => LocalService.write(chatProvider.chatList, context),
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () => showModalSheet(context: context),
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
