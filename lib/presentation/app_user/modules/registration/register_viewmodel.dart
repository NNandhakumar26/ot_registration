import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/helper/bloc/file_picker/picker_bloc.dart';
import 'package:ot_registration/data/model/basic_info.dart';
import 'package:ot_registration/data/model/therapist.dart';
import 'package:ot_registration/data/model/therapy_center.dart';
import 'package:ot_registration/helper/base_class/base_view_model.dart';
import 'package:ot_registration/main.dart';
import 'package:ot_registration/presentation/app_user/bloc/user_bloc.dart';
import 'package:ot_registration/presentation/app_user/user_repo.dart';

class RegisterViewModel extends BaseViewModel {
  late ValueNotifier<bool> mastersCheckBox;
  late ValueNotifier<String> registerType;
  String? filePath;
  String? fileName;

  late TextEditingController nameController;
  late TextEditingController mailController;
  late TextEditingController contactNumberController;
  late TextEditingController addressController;

  // Therapist Info

  late TextEditingController aiotaController;
  late TextEditingController genderController;
  late TextEditingController ageController;
  late TextEditingController designationController;
  late TextEditingController organizationNameController;
  late TextEditingController botAtController;
  late TextEditingController specialisationController;
  late TextEditingController qualificationsController;

  late TextEditingController clinicNameController;
  late TextEditingController clinicTypeController;
  late TextEditingController clinicHeadController;
  late TextEditingController workingHoursController;
  late TextEditingController websiteController;

  late GlobalKey<FormState> therapistFormKey;
  late GlobalKey<FormState> clinicFormKey;

  List<Map> services = [];
  late BuildContext context;
  String? therapistCertificate;

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

  void initializeContext(BuildContext context) {
    this.context = context;
  }

  void preLoadValues(bool isTherapist) {
    UserRepo repo = getIt.get<UserRepo>();
    if (isTherapist) {
      nameController.text = repo.user.therapistInfo?.name ?? '';
      addressController.text = repo.user.therapistInfo?.location ?? '';
      mailController.text = repo.user.therapistInfo?.email ??
          FirebaseAuth.instance.currentUser?.email ??
          '';
      contactNumberController.text = repo.user.therapistInfo?.phone ?? '';
      ageController.text = repo.user.therapist?.age ?? '';
      designationController.text = repo.user.therapist?.designation ?? '';
      botAtController.text = repo.user.therapist?.botAt ?? '';
      specialisationController.text = repo.user.therapist?.specialisation ?? '';
      genderController.text = repo.user.therapist?.gender ?? '';
      qualificationsController.text = repo.user.therapist?.other ?? '';
      mastersCheckBox.value = specialisationController.text.isNotEmpty;
      aiotaController.text = repo.user.therapist?.aiotaMembership ?? '';
      organizationNameController.text =
          repo.user.therapist?.organizationName ?? '';
      if (repo.user.therapist?.certificate != null) {
        therapistCertificate = repo.user.therapist?.certificate;
        context.read<PickerBloc>().add(
              InitializeWithFile(
                filePath: repo.user.therapist!.certificate!,
              ),
            );
      }
    } else {
      nameController.text = repo.user.organizationInfo?.name ?? '';
      addressController.text = repo.user.organizationInfo?.location ?? '';
      mailController.text = repo.user.organizationInfo?.email ??
          FirebaseAuth.instance.currentUser?.email ??
          '';
      contactNumberController.text = repo.user.organizationInfo?.phone ?? '';
      clinicNameController.text = repo.user.organizationInfo?.name ?? '';
      clinicTypeController.text =
          repo.user.organization?.organizationType ?? '';
      clinicHeadController.text =
          repo.user.organization?.organizationHead ?? '';
      workingHoursController.text = repo.user.organization?.workingHours ?? '';
      websiteController.text = repo.user.organization?.website ?? '';
      if (repo.user.organization?.services != null) {
        repo.user.organization!.services!.forEach((element) {
          services.add({
            'service': element['service'],
            'charge': element['charge'],
          });
        });
      }
    }
  }

  void registerUser(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!therapistFormKey.currentState!.validate()) return;

    if (filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attach BOT certificate')));
      return;
    }

    context.read<UserBloc>().add(
          RegisterTherapist(
            exisitingCertificate: therapistCertificate,
            filePath: filePath,
            fileName: fileName,
            context: context,
            therapist: Therapist(
              createdAt: DateTime.now().millisecondsSinceEpoch,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
              age: ageController.text,
              botAt: botAtController.text,
              certificate: filePath!,
              designation: designationController.text,
              gender: genderController.text,
              otMasters: mastersCheckBox.value,
              other: qualificationsController.text,
              specialisation: specialisationController.text,
              organizationName: organizationNameController.text,
              aiotaMembership: aiotaController.text,
            ),
            therapistInfo: BasicInfo(
              name: nameController.text,
              location: addressController.text,
              email: mailController.text,
              phone: contactNumberController.text,
              organizationName: organizationNameController.text,
            ),
          ),
        );

    // context.read<AuthBloc>().add(
    //       RegisterTherapist(
    //           // name: nameController.text,
    //           // gender: genderController.text,
    //           // fileName: fileName!,
    //           // organizationName: organizationNameController.text,
    //           // age: ageController.text,
    //           // designation: designationController.text,
    //           // botAt: botAtController.text,
    //           // filePath: filePath!,
    //           // isMaster: mastersCheckBox.value,
    //           // specialisation: specialisationController.text,
    //           // other: qualificationsController.text,
    //           // aiota: aiotaController.text,
    //           // address: addressController.text,
    //           // mail: mailController.text,
    //           // contactNumber: contactNumberController.text,
    //           ),
    //     );
  }

  void registerClinic(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!clinicFormKey.currentState!.validate()) return;
    if (services.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add atleast one service & charge')));
      return;
    }
    context.read<UserBloc>().add(
          RegisterClinic(
            context: context,
            organization: Organization(
              organizationHead: clinicHeadController.text,
              organizationType: clinicTypeController.text,
              services: services,
              website: websiteController.text,
              workingHours: workingHoursController.text,
            ),
            organizationInfo: BasicInfo(
              name: clinicNameController.text,
              location: addressController.text,
              email: mailController.text,
              phone: contactNumberController.text,
            ),
            // services: services,
            // address: addressController.text,
            // type: clinicTypeController.text,
            // head: clinicHeadController.text,
            // contactNumber: contactNumberController.text,
            // mail: mailController.text,
            // name: clinicNameController.text,
            // website: websiteController.text,
            // workingHours: workingHoursController.text,
          ),
        );
  }
}
