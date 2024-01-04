import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';
import 'package:ot_registration/helper/utils/constants.dart';
import 'package:ot_registration/helper/utils/utils.dart';

import '../blocs/chat_bloc/chat_bloc.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_item.dart';
import 'chat_viewmodel.dart';

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
        title: Text('Chat Group'),
      ),
      body: ColoredBox(
        color: AppColor.scaffoldBackgroundDark,
        child: Column(
          children: [
            Expanded(child: ChatList()),
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

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatViewModel viewModel = ChatViewModel();

    return BlocBuilder<ChatBloc, ChatState>(builder: (_, state) {
      if (state is MessageReceivedLoading) {
        return Wrap(children: const [Utils.buttonProgressIndicator]);
      } else if (state is MessageReceivedSuccess ||
          state is MessageSendSuccess) {
        if (state is MessageReceivedSuccess) {
          viewModel.messages = state.messages;
        }

        return ListView.builder(
            itemCount: viewModel.messages.length,
            reverse: true,
            itemBuilder: (_, index) {
              return ChatItem(
                name: viewModel.messages[index].name,
                userImage: viewModel.messages[index].userImage ??
                    Constants.commonAvatar,
                contentId: viewModel.messages[index].contentId,
                contentImg: viewModel.messages[index].contentImage,
                content: viewModel.messages[index].content,
                date: viewModel.messages[index].dateTime,
                isMe: viewModel.messages[index].isMe,
              );
            });
      } else {
        return const SizedBox();
      }
    });
  }
}
