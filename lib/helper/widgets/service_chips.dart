import 'package:flutter/material.dart';

import 'package:ot_registration/helper/resources/color_manager.dart';

class ServiceChips extends StatefulWidget {
  final ValueChanged onValueChanged;
  const ServiceChips({super.key, required this.onValueChanged});

  @override
  State<ServiceChips> createState() => _ServiceChipsState();
}

class _ServiceChipsState extends State<ServiceChips> {
  late List<Map> services;
  late TextEditingController serviceController;
  late TextEditingController chargeController;

  @override
  void initState() {
    services = [];
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
                  label: Text("${e['service']} : ${e['charge']}")),
            );
          }).toList(),
        ),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: TextFormField(
                decoration: const InputDecoration(hintText: 'Service Name'),
                controller: serviceController,
                style: const TextStyle(fontSize: 16),
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
                style: const TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  if (serviceController.text.isNotEmpty &&
                      chargeController.text.isNotEmpty) {
                    if (services.any((element) =>
                        element['service'] == serviceController.text.trim())) {
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
