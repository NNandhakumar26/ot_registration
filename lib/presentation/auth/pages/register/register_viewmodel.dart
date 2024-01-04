import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/presentation/auth/bloc/auth_bloc.dart';
import 'package:ot_registration/helper/base_class/base_view_model.dart';

class RegisterViewModel extends BaseViewModel {
  late ValueNotifier<bool> mastersCheckBox;
  late ValueNotifier<String> registerType;
  String? filePath;
  String? fileName;

  late TextEditingController nameController;
  late TextEditingController genderController;
  late TextEditingController ageController;
  late TextEditingController designationController;
  late TextEditingController organizationNameController;
  late TextEditingController botAtController;
  late TextEditingController specialisationController;
  late TextEditingController qualificationsController;
  late TextEditingController aiotaController;
  late TextEditingController mailController;
  late TextEditingController contactNumberController;

  late TextEditingController clinicNameController;
  late TextEditingController clinicTypeController;
  late TextEditingController clinicHeadController;
  late TextEditingController workingHoursController;
  late TextEditingController addressController;
  late TextEditingController websiteController;

  late GlobalKey<FormState> therapistFormKey;
  late GlobalKey<FormState> clinicFormKey;
  List<Map> services = [];

  @override
  void dispose() {}

  @override
  void start() {
    mastersCheckBox = ValueNotifier(false);
    registerType = ValueNotifier('Therapist');

    services = [];
    nameController = TextEditingController();
    genderController = TextEditingController(text: 'Male');
    ageController = TextEditingController();
    designationController = TextEditingController();
    organizationNameController = TextEditingController();
    botAtController = TextEditingController();
    specialisationController = TextEditingController();
    qualificationsController = TextEditingController();
    aiotaController = TextEditingController();
    mailController = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.email ?? '');
    contactNumberController = TextEditingController();
    addressController = TextEditingController();

    clinicNameController = TextEditingController();
    clinicTypeController = TextEditingController();
    clinicHeadController = TextEditingController();
    workingHoursController = TextEditingController();
    websiteController = TextEditingController();

    therapistFormKey = GlobalKey<FormState>();
    clinicFormKey = GlobalKey<FormState>();
  }

  void registerUser(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!therapistFormKey.currentState!.validate()) return;

    if (filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attach BOT certificate')));
      return;
    }

    context.read<AuthBloc>().add(RegisterUser(
        name: nameController.text,
        gender: genderController.text,
        fileName: fileName!,
        organizationName: organizationNameController.text,
        age: ageController.text,
        designation: designationController.text,
        botAt: botAtController.text,
        filePath: filePath!,
        isMaster: mastersCheckBox.value,
        specialisation: specialisationController.text,
        other: qualificationsController.text,
        aiota: aiotaController.text,
        address: addressController.text,
        mail: mailController.text,
        contactNumber: contactNumberController.text));
  }

  void registerClinic(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!clinicFormKey.currentState!.validate()) return;
    if (services.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add atleast one service & charge')));
      return;
    }
    context.read<AuthBloc>().add(RegisterClinic(
        services: services,
        address: addressController.text,
        type: clinicTypeController.text,
        head: clinicHeadController.text,
        contactNumber: contactNumberController.text,
        mail: mailController.text,
        name: clinicNameController.text,
        website: websiteController.text,
        workingHours: workingHoursController.text));
  }
}
