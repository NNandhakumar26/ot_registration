import 'package:flutter/material.dart';
import 'package:ot_registration/helper/utils/constants.dart';
import 'package:ot_registration/presentation/blog/widgets/radio_list.dart';

import '../../../helper/widgets/button_wl.dart';

class ReportSheet extends StatefulWidget {
  final ValueChanged onReported;
  const ReportSheet({super.key, required this.onReported});

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  late bool isSelected;
  late bool others;

  String reason = '';

  late TextEditingController controller;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    isSelected = false;
    others = false;

    formKey = GlobalKey();
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox.shrink(),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Text(
              'Why are you reporting this post?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 32,
            ),
            RadioList(
                items: Constants.reports,
                onChanged: (val) {
                  setState(() {
                    isSelected = true;
                    reason = val;
                    if (val == 'Others') {
                      others = true;
                      reason = '';
                    }
                  });
                },
                value: ''),
            const SizedBox(
              height: 32,
            ),
            // if(others)
            // TextFormField(
            //   controller: controller,
            //   validator: (value) => ValidationManager.validateNonNullOrEmpty(value, 'Reason'),
            //   textCapitalization: TextCapitalization.sentences,
            //   decoration:
            //       const InputDecoration(labelText: 'Reason *'),
            // ),
            if (others)
              const SizedBox(
                height: 32,
              ),

            if (isSelected)
              ButtonWL(
                  text: 'Submit',
                  isLoading: false,
                  onPressed: () {
                    // if(!formKey.currentState!.validate()){
                    //   return;
                    // }
                    widget
                        .onReported(reason.isEmpty ? controller.text : reason);
                    Navigator.pop(context);
                  })
          ],
        ),
      ),
    );
  }
}
