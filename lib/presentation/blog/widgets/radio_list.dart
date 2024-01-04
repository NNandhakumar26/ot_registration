import 'package:flutter/material.dart';

class RadioList extends StatefulWidget {
  final List<String> items;
  final ValueChanged onChanged;
  final String value;

  const RadioList({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value
  });

  @override
  State<RadioList> createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {

  late var gValue;

  @override
  void initState() {
    gValue = widget.value;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.items.map((e){
          return RadioListTile(
            value: e, 
            title: Text(e),
            groupValue: gValue, 
            onChanged: (val){
              setState(() {
                gValue = e;
              });
              widget.onChanged(e);
            });
        })
      ],
    );
  }
}