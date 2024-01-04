import 'package:flutter/material.dart';

import 'package:ot_registration/helper/resources/color_manager.dart';
import 'package:ot_registration/helper/resources/font_manager.dart';

class SingleSelect extends StatefulWidget {
  final List<String>? items;
  final Map? itemIconMap;
  final String? preSelected;
  final String? hintText;
  final String? labelText;
  final ValueChanged onChanged;

  const SingleSelect(
      {super.key,
      this.items,
      this.itemIconMap,
      this.labelText,
      this.hintText,
      this.preSelected,
      required this.onChanged});

  @override
  State<SingleSelect> createState() => _SingleSelectState();
}

class _SingleSelectState extends State<SingleSelect> {
  dynamic selected;

  @override
  void initState() {
    selected = widget.preSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: widget.labelText,
              hintText: widget.hintText,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(5)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.error, width: 0.5),
                  borderRadius: BorderRadius.circular(5)),
            ),
            style: TextStyle(
                fontSize: 16,
                color: AppColor.darkGrey,
                fontWeight: FontWeightManager.regular),
            items: widget.items != null
                ? widget.items!
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList()
                : widget.itemIconMap!.keys
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Row(
                          children: [
                            Icon(widget.itemIconMap![e], size: 14),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(e),
                            )
                          ],
                        )))
                    .toList(),
            onChanged: (value) {
              setState(() {
                selected = value;
              });
              widget.onChanged(value);
            },
            // hint: widget.label!=null
            //   ? Text(
            //     widget.label!,
            //     style: Theme.of(context).inputDecorationTheme.hintStyle)
            //   : null,
            value: selected));
  }
}
