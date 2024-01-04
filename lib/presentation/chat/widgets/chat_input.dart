import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';
import 'package:ot_registration/helper/utils/utils.dart';
import '../blocs/chat_bloc/chat_bloc.dart';
import '../blocs/image_bloc/image_bloc.dart';
import '../pages/chat_viewmodel.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatViewModel viewModel = ChatViewModel();

    return BlocBuilder<ImageBloc, ImageState>(builder: (_, state) {
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
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "Type a message...",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.black38),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                      // suffixIcon: state is! ImageFetched ? IconButton(
                      //   onPressed: (){
                      //     BlocProvider.of<ImageBloc>(context).add(GetImageEvent());
                      //   },
                      //   splashRadius: 20,
                      //   icon: const Icon(FontAwesomeIcons.image, color: Colors.grey,size: 18,),
                      // ) : null,
                      enabledBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          //borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.transparent))),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor.primary,
                  child: IconButton(
                    onPressed: () {
                      BlocProvider.of<ChatBloc>(context).add(SendMessageEvent(
                          content: viewModel.chatInputController.text,
                          contentImage: path));
                      viewModel.chatInputController.text = "";
                    },
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ))
            ],
          )
        ],
      );
    });
  }
}
