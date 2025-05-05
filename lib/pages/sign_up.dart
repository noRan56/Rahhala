import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/models/model/shared_perferences.dart';
import 'package:travel_app/pages/home.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final supabase = Supabase.instance.client;
  File? _userImage;
  String? _userName;
  final _future = Supabase.instance.client.from('users').select();

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: data.name,
        password: data.password,
      );

      if (response.user == null) {
        return 'Login failed';
      }

      // Get user data from Supabase
      final userData =
          await supabase.from('users').select().eq('email', data.name).single();

      _userName = userData['username'];
      await SharedPerferencesHelper.saveUserName(_userName!);

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      // 1. Create auth user
      final response = await supabase.auth.signUp(
        email: data.name!,
        password: data.password!,
      );

      if (response.user == null) {
        return 'Registration failed';
      }

      // String id = randomAlphaNumeric(10);
      String userName = data.name!.split('@').first;

      // 2. Add user to profiles table
      await supabase.from('users').insert({
        'id': response.user!.id, // 👈 أضفتي الـ user_id هنا

        'email': data.name!,
        'username': userName,
        'image': 'assets/images/user.png',
      });

      // Save to SharedPreferences
      // await SharedPerferencesHelper.saveUserId(userId);
      await SharedPerferencesHelper.saveUserEmail(data.name!);
      await SharedPerferencesHelper.saveUserName(userName);

      _userName = userName;

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _recoverPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: 'Rahhala',
        logo: const AssetImage('assets/images/travel.png'),
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
        onRecoverPassword: _recoverPassword,
        loginProviders: [
          LoginProvider(
            icon: Icons.g_mobiledata,
            label: 'Google',
            callback: () async {
              await supabase.auth.signInWithOAuth(
                OAuthProvider.google,
                redirectTo: 'io.supabase.flutter://login-callback/',
              );
              return null;
            },
          ),
        ],
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
    );
  }
}
