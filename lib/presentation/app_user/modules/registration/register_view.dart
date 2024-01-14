import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/presentation/app_user/bloc/user_bloc.dart';
import 'package:ot_registration/presentation/app_user/modules/registration/clinic_form.dart';
import 'package:ot_registration/presentation/app_user/modules/registration/register_viewmodel.dart';
import 'package:ot_registration/presentation/app_user/modules/registration/therapist_form.dart';

import '../../../../app/helper/widgets/single_select.dart';

class RegisterView extends StatefulWidget {
  final bool isUpdateProfile;
  final bool isTherapist;
  final bool isOrganization;

  const RegisterView({
    this.isUpdateProfile = false,
    this.isTherapist = false,
    this.isOrganization = false,
    super.key,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late RegisterViewModel _viewmodel;

  @override
  void initState() {
    _viewmodel = RegisterViewModel()
      ..start()
      ..initializeContext(context);
    if (widget.isUpdateProfile) {
      _viewmodel.preLoadValues(widget.isTherapist);
      _viewmodel.registerType.value =
          widget.isTherapist ? 'Therapist' : 'Organization';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listenWhen: (previous, current) =>
          current is Registered ||
          current is RegisterFailure ||
          current is Registering,
      listener: (context, state) {
        if (state is Registering) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Registering'),
              content: Text('Please wait...'),
            ),
          );
        } else if (state is Registered) {
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: Text('Success'),
          //     content: Text('You have been registered successfully'),
          //     actions: [
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //           Navigator.pop(context);
          //         },
          //         child: Text('OK'),
          //       )
          //     ],
          //   ),
          // );
        } else if (state is RegisterFailure) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                )
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('Registration'),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: !widget.isUpdateProfile,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 4,
                            right: 16,
                          ),
                          child: Text(
                            'Registering As A',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                          ),
                        ),
                        Expanded(
                          child: SingleSelect(
                            preSelected: 'Therapist',
                            onChanged: (val) {
                              _viewmodel.registerType.value = val;
                            },
                            items: const ['Therapist', 'Organization'],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor.withOpacity(0.32),
                // endIndent: 16,
                // indent: 16,
                thickness: 1.2,
                // height: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: _viewmodel.registerType,
                  builder: (_, __, ___) {
                    return Visibility(
                      visible: _viewmodel.registerType.value == 'Therapist',
                      replacement: ClinicForm(
                        viewmodel: _viewmodel,
                      ),
                      child: TherapistForm(
                        viewmodel: _viewmodel,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
