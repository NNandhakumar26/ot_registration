import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ot_registration/app/resources/color_manager.dart';

import 'package:ot_registration/helper/utils/constants.dart';
import 'package:ot_registration/helper/utils/utils.dart';
import '../blocs/chat_bloc/chat_bloc.dart';
import 'chat_item_wrapper.dart';
import 'loading.dart';

class ChatItem extends StatelessWidget {
  final String content;
  final String name;
  final String? contentImg;
  final String contentId;
  final int date;
  final bool isMe;
  final String userImage;

  const ChatItem(
      {Key? key,
      required this.contentImg,
      required this.content,
      required this.name,
      required this.contentId,
      required this.date,
      required this.isMe,
      required this.userImage,
      r})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier deleteShow = ValueNotifier<bool>(false);

    return ValueListenableBuilder(
        valueListenable: deleteShow,
        builder: (_, isDeleteShow, child) {
          return PopScope(
            // onWillPop: () async {
            //   if (deleteShow.value) {
            //     deleteShow.value = false;
            //     return false;
            //   }
            //   return true;
            // },
            canPop: !deleteShow.value,
            onPopInvoked: (didPop) {
              if (deleteShow.value) deleteShow.value = false;
            },
            child: Container(
                color: deleteShow.value
                    ? AppColor.primaryChatLight2
                    : Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onLongPress: () => deleteShow.value = true,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (deleteShow.value && isMe)
                            InkWell(
                              onTap: () async {
                                bool? shouldDelete = await showDialog(
                                  context: context,
                                  builder: (builder) => AlertDialog(
                                    title: Text('Delete Message'),
                                    content: Text(
                                        'Are you sure you want to delete this message?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: Text('Yes')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text('No')),
                                    ],
                                  ),
                                );
                                if (shouldDelete ?? false) {
                                  BlocProvider.of<ChatBloc>(context).add(
                                      DeleteMessageEvent(contentId: contentId));
                                }
                                deleteShow.value = false;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 10, right: 22),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (contentImg != null)
                            ChatItemWrapper(
                              isMe: isMe,
                              name: name,
                              date: date,
                              userImage: userImage,
                              isImage: true,
                              child: GestureDetector(
                                onTap: () => showImageBottomSheet(context),
                                child: Image.network(
                                  contentImg!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    return loadingProgress == null
                                        ? child
                                        : const SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: LoadingWidget(
                                                type: Constants.shimmer_1),
                                          );
                                  },
                                ),
                              ),
                            ),
                          if (contentImg != null) Utils.verticalDividerMedium,
                          if (content.isNotEmpty)
                            ChatItemWrapper(
                              name: name,
                              isMe: isMe,
                              date: date,
                              userImage: userImage,
                              isImage: false,
                              child: Text(
                                content,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }

  void showImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        barrierColor: Theme.of(context).shadowColor.withOpacity(0.6),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 450,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    FontAwesomeIcons.x,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                    child: InteractiveViewer(
                  minScale: 0.1,
                  maxScale: 2,
                  boundaryMargin: const EdgeInsets.all(10),
                  child: Center(
                    child: Image.network(contentImg!, fit: BoxFit.contain),
                  ),
                ))
              ],
            ),
          );
        });
  }
}
