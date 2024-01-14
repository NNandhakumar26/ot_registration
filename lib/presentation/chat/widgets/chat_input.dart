import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/resources/color_manager.dart';
import 'package:ot_registration/helper/utils/utils.dart';
import '../blocs/chat_bloc/chat_bloc.dart';
import '../blocs/image_bloc/image_bloc.dart';
import '../pages/chat_viewmodel.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatViewModel viewModel = ChatViewModel();

    return BlocBuilder<ImageBloc, ImageState>(
      builder: (_, state) {
        var path = state is ImageFetched ? state.image.path : null;

        return Column(
          children: [
            if (state is ImageFetched)
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    constraints: const BoxConstraints(
                        maxHeight: 200, minWidth: double.infinity),
                    child: Image.file(
                      state.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      right: 0,
                      child: Container(
                        color: AppColor.primary,
                        child: IconButton(
                            onPressed: () {
                              BlocProvider.of<ImageBloc>(context)
                                  .add(CancelImageEvent());
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            )),
                      ))
                ],
              ),
            if (state is ImageFetched) Utils.dividerMedium,
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 4,
                    minLines: 1,
                    autofocus: true,
                    controller: viewModel.chatInputController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Type a message...",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.black38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    onPressed: () {
                      if (viewModel.chatInputController.text.trim().isEmpty) {
                        return;
                      }
                      BlocProvider.of<ChatBloc>(context).add(
                        SendMessageEvent(
                          content: viewModel.chatInputController.text,
                          contentImage: path,
                        ),
                      );
                      viewModel.chatInputController.text = "";
                    },
                    splashRadius: 20,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
