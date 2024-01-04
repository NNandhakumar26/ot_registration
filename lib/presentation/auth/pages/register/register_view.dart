import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/presentation/auth/bloc/auth_bloc.dart';
import 'package:ot_registration/presentation/auth/pages/register/clinic_form.dart';
import 'package:ot_registration/presentation/auth/pages/register/register_viewmodel.dart';
import 'package:ot_registration/presentation/auth/pages/register/therapist_form.dart';
import 'package:ot_registration/helper/widgets/dialog.dart';

import 'package:ot_registration/helper/resources/color_manager.dart';
import '../../../../helper/widgets/single_select.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late RegisterViewModel _viewmodel;

  @override
  void initState() {
    _viewmodel = RegisterViewModel()..start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is RegisterSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.userFeed,
                arguments: state.user,
                (Route<dynamic> route) => false);
          } else if (state is Loading) {
            showLoaderDialog(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('REGISTER'),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                    onPressed: () {
                      if (_viewmodel.registerType.value == 'Therapist') {
                        _viewmodel.registerUser(context);
                      } else {
                        _viewmodel.registerClinic(context);
                      }
                    },
                    splashRadius: 20,
                    icon: Icon(
                      Icons.check_circle,
                      size: 30,
                      color: AppColor.darkPrimary,
                    )),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Register As A',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: AppColor.grey)),
                ),
                SingleSelect(
                  preSelected: 'Therapist',
                  onChanged: (val) {
                    _viewmodel.registerType.value = val;
                  },
                  items: const ['Therapist', 'Organization'],
                ),
                Divider(
                  color: AppColor.transparent,
                ),
                ValueListenableBuilder(
                  valueListenable: _viewmodel.registerType,
                  builder: (_, __, ___) {
                    return Visibility(
                      visible: _viewmodel.registerType.value == 'Therapist',
                      replacement: ClinicForm(viewmodel: _viewmodel),
                      child: TherapistForm(
                        viewmodel: _viewmodel,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
