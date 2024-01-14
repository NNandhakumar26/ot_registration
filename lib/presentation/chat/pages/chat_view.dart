import 'package:flutter/material.dart';
import 'package:ot_registration/presentation/chat/pages/chat_list.dart';
import '../widgets/chat_input.dart';
import 'package:ot_registration/app/resources/color_manager.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainBody();
  }
}

class MainBody extends StatelessWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
      ),
      body: ColoredBox(
        color: AppColor.scaffoldBackgroundDark,
        child: Column(
          children: [
            Expanded(
              child: ChatList(),
            ),
            Container(
              color: AppColor.scaffoldBackgroundLight,
              padding: EdgeInsets.only(left: 18, right: 18, bottom: 10, top: 0),
              child: ChatInput(),
            ),
          ],
        ),
      ),
    );
  }
}
