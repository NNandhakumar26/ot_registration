import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ot_registration/app/config/dependencies.dart';
import 'package:ot_registration/data/network/utils/references.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

import '../../../../data/model/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  final UserRepo userRepo = getIt<UserRepo>();
  var repo = FirebaseReferences();
  String? startAfterDocumentId;

  ChatBloc() : super(ChatInitial()) {
    // on<RequestMessageEvent>(onRequestMessages);
    on<MessageReceivedEvent>(onMessageReceived);
    on<SendMessageEvent>(onMessageSend);
    on<DeleteMessageEvent>(onDeleteMessage);
  }

  // void onRequestMessages(RequestMessageEvent event, Emitter emit) async {
  //   emit(MessageReceivedLoading());
  //   final querySnapShotStream = fireStore
  //       .collection("group_chat")
  //       .orderBy("dateTime", descending: true)
  //       // .limit(10)
  //       .snapshots();

  //   Stream queryStream = querySnapShotStream.map((event) => event.docs.map(
  //         (e) {
  //           var docMap = e.data();
  //           docMap["contentId"] = e.id;
  //           return docMap;
  //         },
  //       ).toList());

  //   queryStream.listen((messages) {
  //     add(
  //       MessageReceivedEvent(
  //         messages: Message.getMessageList(messages),
  //       ),
  //     );
  //   });
  // }

  void onMessageReceived(MessageReceivedEvent event, Emitter emit) {
    emit(MessageReceivedSuccess(messages: event.messages));
  }

  void onMessageSend(SendMessageEvent event, Emitter emit) async {
    String? contentImageUrl;

    if (event.contentImage != null) {
      contentImageUrl = await uploadImage(event.contentImage!);
    }

    var message = {
      "userId": user?.uid,
      // "userImage": user?.photoURL,
      "name": FirebaseAuth.instance.currentUser!.displayName,
      'emailId': FirebaseAuth.instance.currentUser!.email,
      "dateTime": DateTime.now().microsecondsSinceEpoch,
      "content": event.content,
      if (contentImageUrl != null) "contentImageUrl": contentImageUrl,
      if (userRepo.isAdmin) 'isAdmin': true,
    };
    await fireStore.collection("group_chat").add(message);
    emit(MessageSendSuccess());
  }

  Future<String> uploadImage(String path) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(user!.uid)
        .child("chat")
        .child(path.split('/').last);
    await reference.putFile(File(path));
    return Future.value(await reference.getDownloadURL());
  }

  void onDeleteMessage(DeleteMessageEvent event, Emitter emit) async {
    fireStore.collection("group_chat").doc(event.contentId).delete();
  }
}
