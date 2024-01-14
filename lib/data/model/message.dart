import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message extends Equatable {
  final String userId;
  final int dateTime;
  final String content;
  final String messageId;
  final String name;
  final String? imageUrl;
  final bool isAdmin;

  const Message({
    required this.userId,
    required this.dateTime,
    required this.content,
    required this.name,
    required this.messageId,
    required this.imageUrl,
    this.isAdmin = false,
  });

  // static List<Message> getMessageList(List<Map<String, dynamic>> data) {
  //   return data.map((e) => Message.fromJson(e)).toList();
  // }

  factory Message.fromJson(Map<String, dynamic> data, String id) {
    return Message(
      name: data['name'] ?? 'New User',
      userId: data['userId'] ?? '',
      messageId: id,
      dateTime: data['dateTime'],
      content: data['content'],
      imageUrl: data['imageUrl'] ?? null,
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        dateTime,
        content,
        messageId,
      ];
}
