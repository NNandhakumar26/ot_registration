import 'package:flutter/material.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';
import 'package:ot_registration/helper/utils/date_utils.dart';

import 'package:ot_registration/helper/utils/utils.dart';

class ChatItemWrapper extends StatelessWidget {
  final bool isMe;
  final bool isImage;
  final Widget child;
  final int date;
  final String name;
  final String userImage;

  const ChatItemWrapper(
      {Key? key,
      required this.isMe,
      required this.child,
      required this.name,
      required this.date,
      required this.isImage,
      required this.userImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 30, right: 5),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(userImage),
            ),
          ),
        Stack(
          children: [
            /* Positioned(
              bottom: 0,
              right: isMe ? 0 : null,
              child: Transform(
                transform: Matrix4.rotationY(isMe ? pi : 0),
                child: CustomPaint(
                  painter: ChatBubbleTriangle(
                      color:
                          isMe ? AppColor.primary : AppColor.primaryChatLight2),
                ),
              ),
            ), */
            Container(
              padding: EdgeInsets.all(isImage ? 5 : 10),
              constraints:
                  BoxConstraints(minWidth: 50, maxWidth: isImage ? 200 : 300),
              decoration: BoxDecoration(
                  color: isMe
                      ? AppColor.primary
                      : AppColor.primary.withOpacity(0.064),
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        )),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  child,
                  Utils.verticalDividerMedium,
                  Text(
                    '$name . ${DateTimeUtils.formatDate(date)}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          // fontSize: 10,
                          color: isMe ? Colors.white54 : Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
        if (isMe)
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              width: 15,
            ),
          ),
      ],
    );
  }
}

class ChatBubbleTriangle extends CustomPainter {
  final Color color;

  ChatBubbleTriangle({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;

    var path = Path();
    path.lineTo(-20, 0);
    path.quadraticBezierTo(10, -10, 5, -30);
    path.lineTo(10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
