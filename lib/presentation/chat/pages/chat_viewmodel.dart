import 'package:flutter/cupertino.dart';

import '../../../data/model/message.dart';

class ChatViewModel {
  static late ChatViewModel _instance;

  factory ChatViewModel() {
    _instance = ChatViewModel._internal();
    return _instance;
  }

  ChatViewModel._internal() {
    _init();
  }

  late TextEditingController chatInputController;
  late List<Message> messages;

  _init() {
    messages = [];
    chatInputController = TextEditingController();
  }
}
