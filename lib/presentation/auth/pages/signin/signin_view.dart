import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ot_registration/app/routes.dart';
import 'package:ot_registration/helper/utils/navigator.dart';
import 'package:ot_registration/presentation/auth/bloc/auth_bloc.dart';
import 'package:ot_registration/helper/utils/global.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is GuestUser) {
            Global.isGuest = true;
            CustomNav.navigate(context, Routes.userFeed);
          } else if (state is AuthSuccess) {
            if (Global.isAdmin || state.isOldUser) {
              CustomNav.navigate(context, Routes.home);
            } else {
              CustomNav.navigate(context, Routes.register);
            }
          } else if (state is AuthFailure) {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/welcome.png'),
              const SizedBox(height: 60),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (_, state) {
                  return (state is! Loading)
                      ? SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: SignInButton(
                            shape: StadiumBorder(),
                            Buttons.google,
                            text: "Sign up with Google",
                            onPressed: () =>
                                context.read<AuthBloc>().add(GoogleLogin()),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator()),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Signing in...',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color: Colors.black45,
                                  ),
                            ),
                          ],
                        );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: SignInButtonBuilder(
                  shape: StadiumBorder(),
                  text: 'Sign in as a Guest',
                  icon: Icons.person,
                  highlightColor: Theme.of(context).primaryColor,
                  onPressed: () => context.read<AuthBloc>().add(GuestSignIn()),
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.64),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
