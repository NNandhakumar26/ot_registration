import 'package:flutter/material.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';

class ButtonWL extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Color? bgColor;
  final bool isDisabled;
  final bool isBorder;

  const ButtonWL(
      {super.key,
      required this.text,
      this.height = 56,
      required this.isLoading,
      required this.onPressed,
      this.bgColor,
      this.isDisabled = false,
      this.isBorder = false,
      this.width});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isLoading || isDisabled ? null : onPressed,
        style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
            minimumSize: MaterialStateProperty.all(
                Size(width ?? double.infinity, height)),
            backgroundColor: bgColor != null
                ? MaterialStateProperty.all(bgColor)
                : isBorder
                    ? MaterialStateProperty.all(Colors.white)
                    : null,
            side: MaterialStateProperty.all(BorderSide(
                color: (isLoading || isDisabled) && !isBorder
                    ? Colors.transparent
                    : AppColor.primary))),
        child: isLoading
            ? const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ))
            : Text(
                text,
                style: TextStyle(
                    //fontSize: 16,
                    color: isBorder ? AppColor.primary : null),
              ));
  }
}
