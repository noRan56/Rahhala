import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/data/cubit/user_cubit.dart';

import 'package:travel_app/presentation_layer/view/home_view.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Duration get loginTime => const Duration(milliseconds: 50);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(),
      child: Scaffold(
        body: FlutterLogin(
          title: 'Rahhala',
          logo: const AssetImage('assets/images/travel.png'),
          onLogin:
              (data) =>
                  context.read<UserCubit>().Login(data.name, data.password),
          onSignup:
              (data) => context.read<UserCubit>().signupUser(
                data.name!,
                data.password!,
              ),
          onRecoverPassword:
              (email) => context.read<UserCubit>().recoverPassword(email),
          onSubmitAnimationCompleted: () {
            context.read<UserCubit>().loadUserData();

            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
          },

          theme: LoginTheme(
            primaryColor: Colors.blue,
            accentColor: Colors.white,
            errorColor: Colors.deepOrange,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              letterSpacing: 3,
            ),
            bodyStyle: const TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
            ),
            textFieldStyle: const TextStyle(
              color: Colors.orange,
              shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
            ),
          ),
        ),
      ),
    );
  }
}
