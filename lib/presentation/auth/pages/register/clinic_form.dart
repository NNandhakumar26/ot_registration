import 'package:flutter/material.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';
import 'package:ot_registration/helper/resources/validation_manager.dart';
import 'package:ot_registration/presentation/auth/pages/register/register_viewmodel.dart';
import 'package:ot_registration/helper/widgets/service_chips.dart';

class ClinicForm extends StatelessWidget {
  final RegisterViewModel viewmodel;
  const ClinicForm({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewmodel.clinicFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Organization Name',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.clinicNameController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Name'),
            decoration: const InputDecoration(hintText: 'Name of Organization'),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Organization Type',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.clinicTypeController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Name'),
            decoration: const InputDecoration(hintText: 'Type of Organization'),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Head / Director of the organization',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.clinicHeadController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Name'),
            decoration: const InputDecoration(hintText: ''),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Services',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          ServiceChips(
            onValueChanged: (value) {
              viewmodel.services = value;
            },
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Working Hours',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.workingHoursController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Working Hours'),
            decoration: const InputDecoration(hintText: ''),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Address',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            maxLines: 4,
            controller: viewmodel.addressController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Address'),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintText: '',
            ),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Mail ID',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.mailController,
            validator: (value) => ValidationManager.validateEmail(value),
            decoration: const InputDecoration(hintText: ''),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Contact Number',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.contactNumberController,
            keyboardType: TextInputType.number,
            validator: (value) => ValidationManager.validatePhone(value),
            decoration: const InputDecoration(hintText: ''),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Website',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.websiteController,
            // validator: (value)=> ValidationManager.validateNonNull(value, 'Website'),
            decoration: const InputDecoration(hintText: ''),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
