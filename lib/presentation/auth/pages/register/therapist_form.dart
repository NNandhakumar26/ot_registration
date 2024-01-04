import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/helper/bloc/file_picker/picker_bloc.dart';
import 'package:ot_registration/helper/resources/color_manager.dart';
import 'package:ot_registration/helper/resources/validation_manager.dart';
import 'package:ot_registration/presentation/auth/pages/register/register_viewmodel.dart';
import 'package:ot_registration/helper/widgets/single_select.dart';

class TherapistForm extends StatelessWidget {
  final RegisterViewModel viewmodel;
  const TherapistForm({super.key, required this.viewmodel});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewmodel.therapistFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Name',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.nameController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Name'),
            decoration: const InputDecoration(hintText: 'Full Name'),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('Gender',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColor.grey)),
                  ),
                  SingleSelect(
                    hintText: 'Gender',
                    preSelected: 'Male',
                    onChanged: (val) => viewmodel.genderController.text = val,
                    items: const ['Male', 'Female', 'Non-Binary'],
                  )
                ],
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('Age',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: AppColor.grey)),
                  ),
                  TextFormField(
                    controller: viewmodel.ageController,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    validator: (value) =>
                        ValidationManager.validateNonNull(value, 'Age'),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Age',
                    ),
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ))
            ],
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Organization Name',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.organizationNameController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Organization Name'),
            decoration: const InputDecoration(hintText: 'Organization Name'),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Designation',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.designationController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Designation'),
            decoration: const InputDecoration(hintText: 'Designation'),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Studied BOT at',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.botAtController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Studied Bot'),
            decoration: const InputDecoration(hintText: ''),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Attach Copy Of Certificate',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          BlocBuilder<PickerBloc, PickerState>(builder: (_, state) {
            if (state is FilePicked) {
              viewmodel.filePath = state.file.path;
              viewmodel.fileName = state.fileName;
            } else if (state is Removed) {
              viewmodel.filePath = null;
              viewmodel.fileName = null;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (viewmodel.filePath != null)
                  Expanded(
                      flex: 8,
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                            color: AppColor.white,
                            border:
                                Border.all(color: AppColor.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Expanded(child: Text(viewmodel.fileName!)),
                            GestureDetector(
                                onTap: () => context
                                    .read<PickerBloc>()
                                    .add(RemoveFile()),
                                child: Icon(
                                  Icons.cancel_rounded,
                                  color: AppColor.grey,
                                ))
                          ],
                        ),
                      )),
                Expanded(
                    flex: 4,
                    child: OutlinedButton(
                        onPressed: () =>
                            context.read<PickerBloc>().add(PickFile()),
                        child: Text(
                            viewmodel.filePath != null ? 'Change' : 'Select'))),
              ],
            );
          }),
          Divider(
            color: AppColor.transparent,
          ),
          ValueListenableBuilder(
              valueListenable: viewmodel.mastersCheckBox,
              builder: (_, __, ___) {
                return Column(
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: viewmodel.mastersCheckBox.value,
                      onChanged: (val) => viewmodel.mastersCheckBox.value =
                          !viewmodel.mastersCheckBox.value,
                      title: Text(
                          'Have you done your Masters in Occupational Therapy ?',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColor.grey)),
                    ),
                    Visibility(
                        visible: viewmodel.mastersCheckBox.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: AppColor.transparent,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text('Specialisation',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: AppColor.grey)),
                            ),
                            TextFormField(
                              validator: (value) =>
                                  viewmodel.mastersCheckBox.value
                                      ? ValidationManager.validateNonNull(
                                          value, 'Specialisation')
                                      : null,
                              controller: viewmodel.specialisationController,
                              decoration: const InputDecoration(
                                  hintText: 'Specialisation'),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ))
                  ],
                );
              }),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Other Qualifications',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.qualificationsController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Qualifications'),
            decoration: const InputDecoration(hintText: ''),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('AIOTA Membership',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            controller: viewmodel.aiotaController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'AIOTA Membership'),
            decoration: const InputDecoration(hintText: ''),
            style: const TextStyle(fontSize: 16),
          ),
          Divider(
            color: AppColor.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Work Address',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.grey)),
          ),
          TextFormField(
            maxLines: 4,
            controller: viewmodel.addressController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Work Address'),
            decoration: const InputDecoration(
                hintText: '',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
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
            enabled: false,
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
          OutlinedButton(
              onPressed: () => showpaymentdialog(context),
              child: const Text('Add Payment Info')),
        ],
      ),
    );
  }

  Future showpaymentdialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Add Payment Info'),
            content: Text('You are Redirected into Payment Gateway'),
          );
        });
  }
}
