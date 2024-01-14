import 'package:flutter/material.dart';
import 'package:ot_registration/app/constants/gaps.dart';

import 'package:ot_registration/app/resources/color_manager.dart';
import 'package:ot_registration/helper/utils/toast.dart';

class ServiceChips extends StatefulWidget {
  final List<Map> services;
  final ValueChanged onValueChanged;
  const ServiceChips(
      {super.key, required this.services, required this.onValueChanged});

  @override
  State<ServiceChips> createState() => _ServiceChipsState();
}

class _ServiceChipsState extends State<ServiceChips> {
  late List<Map> services;
  late TextEditingController serviceController;
  late TextEditingController chargeController;

  @override
  void initState() {
    services = widget.services;
    serviceController = TextEditingController();
    chargeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: services.map((e) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: RawChip(
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                ),
                onDeleted: () {
                  services.removeWhere(
                      (element) => element['service'] == e['service']);
                  setState(() {});
                  widget.onValueChanged(services);
                },
                label: Text("${e['service']} : ${e['charge']}"),
              ),
            );
          }).toList(),
        ),
        gapH8,
        Row(
          children: [
            Expanded(
              flex: 8,
              child: TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(hintText: 'Service Name'),
                controller: serviceController,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                decoration: const InputDecoration(hintText: 'Charge'),
                controller: chargeController,
              ),
            ),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  if (serviceController.text.isNotEmpty &&
                      chargeController.text.isNotEmpty) {
                    if (services.any((element) =>
                        element['service'] == serviceController.text.trim())) {
                      showToast(
                        context,
                        message: 'Service already entered',
                        success: false,
                      );
                      return;
                    }
                    services.add({
                      'service': serviceController.text.trim(),
                      'charge': chargeController.text.trim()
                    });
                    setState(() {
                      serviceController.clear();
                      chargeController.clear();
                    });
                    widget.onValueChanged(services);
                  } else {
                    showToast(
                      context,
                      message: 'Fill in the fields',
                      success: false,
                    );
                  }
                },
                color: AppColor.primary,
                icon: const Icon(Icons.add_circle))
          ],
        )
      ],
    );
  }
}
