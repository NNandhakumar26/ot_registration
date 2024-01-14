import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ot_registration/app/helper/widgets/shimmer_card.dart';
import 'package:ot_registration/data/model/message.dart';
import 'package:ot_registration/helper/utils/constants.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

import '../widgets/chat_item.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot> _messagesStream;
  List<Message> _messages = [];
  DocumentSnapshot? _lastVisible;
  bool _isLoading = false;
  var ref = FirebaseFirestore.instance.collection("group_chat");
  final userRepo = getIt.get<UserRepo>();
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = userRepo.uid;
    _messagesStream =
        ref.orderBy('dateTime', descending: true).limit(10).snapshots();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchMoreMessages();
    }
  }

  void _fetchMoreMessages() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot querySnapshot = await _messagesStream.last;
    _lastVisible = querySnapshot.docs.last;

    var newMessages = await FirebaseFirestore.instance
        .collection('chats')
        .orderBy('dateTime', descending: true)
        .startAfterDocument(_lastVisible!)
        .limit(10)
        .get();
    _messages.addAll(newMessages.docs
        .map(
          (doc) => Message.fromJson(doc.data(), doc.id),
        )
        .toList());

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final ChatViewModel viewModel = ChatViewModel();
    return StreamBuilder<QuerySnapshot>(
      stream: _messagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _messages = snapshot.data!.docs
              .map(
                (doc) => Message.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();
          return ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return Center(child: CircularProgressIndicator());
              } else {
                Message message = _messages[index];
                return ChatItem(
                  name: message.name,
                  userImage: Constants.commonAvatar,
                  contentId: message.messageId,
                  contentImg: message.imageUrl,
                  content: message.content,
                  date: message.dateTime,
                  isMe: userId == message.userId,
                );
              }
            },
          );
        } else {
          return ShimmerCard();
        }
      },
    );
  }
}
