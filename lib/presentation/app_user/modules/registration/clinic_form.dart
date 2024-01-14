import 'package:flutter/material.dart';
import 'package:ot_registration/app/constants/gaps.dart';
import 'package:ot_registration/app/resources/validation_manager.dart';
import 'package:ot_registration/presentation/app_user/modules/registration/register_viewmodel.dart';
import 'package:ot_registration/app/helper/widgets/service_chips.dart';

class ClinicForm extends StatelessWidget {
  final RegisterViewModel viewmodel;
  const ClinicForm({super.key, required this.viewmodel});
  final gap = gapH16;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewmodel.clinicFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            controller: viewmodel.clinicNameController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Organization Name'),
            decoration: const InputDecoration(labelText: 'Organization Name'),
          ),
          gap,
          TextFormField(
            controller: viewmodel.clinicTypeController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Organization Type'),
            decoration: const InputDecoration(
              labelText: 'Organization Type',
            ),
          ),
          gap,
          TextFormField(
            controller: viewmodel.clinicHeadController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Field'),
            decoration: const InputDecoration(
                labelText: 'Name of Head / Director of the organization'),
          ),
          gap,
          Text(
            'Services',
            style: titleTheme(context),
          ),
          gapH8,
          ServiceChips(
            services: viewmodel.services,
            onValueChanged: (value) {
              viewmodel.services = value;
            },
          ),
          gap,
          TextFormField(
            controller: viewmodel.workingHoursController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Working Hours'),
            decoration: const InputDecoration(labelText: 'Working Hours'),
          ),
          gap,
          TextFormField(
            maxLines: 4,
            controller: viewmodel.addressController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Address'),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              labelText: 'Address',
            ),
          ),
          gap,
          TextFormField(
            controller: viewmodel.mailController,
            enabled: false,
            validator: (value) => ValidationManager.validateEmail(value),
            decoration: const InputDecoration(labelText: 'Mail ID'),
          ),
          gap,
          TextFormField(
            controller: viewmodel.contactNumberController,
            keyboardType: TextInputType.number,
            validator: (value) => ValidationManager.validatePhone(value),
            decoration: const InputDecoration(labelText: 'Contact Number'),
          ),
          gap,
          TextFormField(
            controller: viewmodel.websiteController,
            // validator: (value)=> ValidationManager.validateNonNull(value, 'Website'),
            decoration: const InputDecoration(labelText: 'Website URL'),
          ),
          gap,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white.withOpacity(0.87),
                elevation: 4,
              ),
              onPressed: () {
                viewmodel.registerClinic(context);
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle titleTheme(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.black54,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );
  }
}
