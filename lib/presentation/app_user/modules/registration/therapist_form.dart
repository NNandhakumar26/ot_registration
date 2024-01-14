import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/constants/gaps.dart';
import 'package:ot_registration/app/helper/bloc/file_picker/picker_bloc.dart';
import 'package:ot_registration/app/resources/color_manager.dart';
import 'package:ot_registration/app/resources/validation_manager.dart';
import 'package:ot_registration/presentation/app_user/modules/registration/register_viewmodel.dart';
import 'package:ot_registration/app/helper/widgets/single_select.dart';

class TherapistForm extends StatelessWidget {
  final RegisterViewModel viewmodel;
  const TherapistForm({super.key, required this.viewmodel});
  final gap = gapH16;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewmodel.therapistFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: viewmodel.nameController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Name'),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Full Name',
            ),
          ),
          gap,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Gender',
                        style: titleTheme(context),
                      ),
                    ),
                    SingleSelect(
                      hintText: 'Gender',
                      preSelected: 'Male',
                      onChanged: (val) => viewmodel.genderController.text = val,
                      items: const ['Male', 'Female', 'Non-Binary'],
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Age',
                      style: titleTheme(context),
                    ),
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
          gap,
          TextFormField(
            controller: viewmodel.organizationNameController,
            keyboardType: TextInputType.name,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Organization Name'),
            decoration: const InputDecoration(labelText: 'Organization Name'),
          ),
          gap,
          TextFormField(
            controller: viewmodel.designationController,
            keyboardType: TextInputType.name,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Designation'),
            decoration: const InputDecoration(labelText: 'Designation'),
          ),
          gap,
          TextFormField(
            controller: viewmodel.botAtController,
            keyboardType: TextInputType.name,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Studied Bot'),
            decoration: const InputDecoration(labelText: 'Studied BOT at'),
          ),
          gap,
          Text(
            'Attach Copy Of Certificate',
            style: titleTheme(context),
          ),
          gapH8,
          BlocBuilder<PickerBloc, PickerState>(
            builder: (_, state) {
              if (state is FilePicked) {
                viewmodel.filePath = state.file.path;
                viewmodel.fileName = state.fileName;
              } else if (state is Removed) {
                viewmodel.filePath = null;
                viewmodel.fileName = null;
              } else if (state is FilePreSelected) {
                viewmodel.filePath = state.fileName;
                viewmodel.fileName = state.fileName;
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
                            Expanded(
                              child: Text(
                                state is FilePreSelected
                                    ? 'Cerficiate'
                                    : viewmodel.fileName!,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.read<PickerBloc>().add(RemoveFile()),
                              child: Icon(
                                Icons.cancel_rounded,
                                color: AppColor.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 4,
                    child: OutlinedButton(
                      onPressed: () =>
                          context.read<PickerBloc>().add(PickFile()),
                      child: Text(
                        viewmodel.filePath != null
                            ? 'Change'
                            : 'Select a Certificate',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          gap,
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
                      style: titleTheme(context),
                    ),
                  ),
                  Visibility(
                    visible: viewmodel.mastersCheckBox.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gap,
                        TextFormField(
                          validator: (value) => viewmodel.mastersCheckBox.value
                              ? ValidationManager.validateNonNull(
                                  value,
                                  'Specialisation',
                                )
                              : null,
                          controller: viewmodel.specialisationController,
                          decoration: const InputDecoration(
                            labelText: 'Specialisation',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
          gap,
          TextFormField(
            keyboardType: TextInputType.name,
            controller: viewmodel.qualificationsController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Qualifications'),
            decoration: const InputDecoration(labelText: 'Qualifications'),
          ),
          gap,
          TextFormField(
            controller: viewmodel.aiotaController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'AIOTA Membership'),
            decoration: const InputDecoration(labelText: 'AIOTA Membership'),
          ),
          gap,
          TextFormField(
            maxLines: 4,
            controller: viewmodel.addressController,
            validator: (value) =>
                ValidationManager.validateNonNull(value, 'Work Address'),
            decoration: const InputDecoration(
              labelText: 'Work Address',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          gap,
          TextFormField(
            controller: viewmodel.mailController,
            enabled: false,
            validator: (value) => ValidationManager.validateEmail(value),
            decoration: const InputDecoration(labelText: 'Mail ID'),
            style: const TextStyle(fontSize: 16),
          ),
          gap,
          TextFormField(
            controller: viewmodel.contactNumberController,
            keyboardType: TextInputType.number,
            validator: (value) => ValidationManager.validatePhone(value),
            decoration: const InputDecoration(labelText: 'Contact Number'),
          ),
          gap,
          Center(
            child: OutlinedButton(
              onPressed: null, // () => showpaymentdialog(context),
              child: const Text('Finish Your Payment'),
            ),
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
                viewmodel.registerUser(context);
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
