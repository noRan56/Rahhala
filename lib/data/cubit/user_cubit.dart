import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/data/cubit/user_state.dart';
import 'package:travel_app/data/repositories/shared_perferences.dart';

final supabase = Supabase.instance.client;

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState()) {}

  Future<void> loadUserData() async {
    try {
      final username = await SharedPerferencesHelper.getUserName();
      final image = await SharedPerferencesHelper.getUserImage();

      emit(
        state.copyWith(
          username: username,
          imageUrl: image,
          status: UserStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: UserStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<String?> signupUser(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return 'Registration failed';
      }

      // String id = randomAlphaNumeric(10);
      String userName = email.split('@').first;

      // 2. Add user to profiles table
      await supabase.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'username': userName,
        'image': 'assets/images/user.png',
      });

      await SharedPerferencesHelper.saveUserName(userName);
      await SharedPerferencesHelper.saveUserEmail(email);
      await SharedPerferencesHelper.saveUserImage('assets/images/user.png');

      emit(
        state.copyWith(
          username: userName,
          imageUrl: 'assets/images/user.png',
          status: UserStatus.loaded,
        ),
      );

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> Login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return 'Login failed';
      }
      if (response.user == null) return 'Login failed';

      final userData =
          await supabase.from('users').select().eq('email', email).single();

      final userName = userData['username'];
      final image = userData['image'];

      await SharedPerferencesHelper.saveUserName(userName);
      await SharedPerferencesHelper.saveUserEmail(email);
      await SharedPerferencesHelper.saveUserImage(image);

      emit(
        state.copyWith(
          username: userName,
          imageUrl: image,
          status: UserStatus.loaded,
        ),
      );

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> recoverPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateUser(String username, String? imageUrl) async {
    try {
      emit(state.copyWith(status: UserStatus.loading));

      // Save to SharedPreferences
      await SharedPerferencesHelper.saveUserName(username);
      if (imageUrl != null) {
        await SharedPerferencesHelper.saveUserImage(imageUrl);
      }

      emit(
        state.copyWith(
          username: username,
          imageUrl: imageUrl,
          status: UserStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: UserStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateProfile({
    required String username,
    File? imageFile,
  }) async {
    final supabase = Supabase.instance.client;
    emit(state.copyWith(status: UserStatus.loading));

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("User not logged in");

      //upload  image to storage
      String? imageUrl = state.imageUrl;
      if (imageFile != null) {
        final imageBytes = await imageFile.readAsBytes();
        final imagePath =
            'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
        //bucket
        await supabase.storage
            .from('profile-pictures')
            .uploadBinary(imagePath, imageBytes);

        imageUrl = supabase.storage
            .from('profile-pictures')
            .getPublicUrl(imagePath);
      }

      // Update Supabase table
      await supabase.from('users').upsert({
        'id': userId,
        'username': username,
        'image': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Save locally
      await SharedPerferencesHelper.saveUserName(username);
      if (imageUrl != null) {
        await SharedPerferencesHelper.saveUserImage(imageUrl);
      }

      emit(
        state.copyWith(
          username: username,
          imageUrl: imageUrl,
          status: UserStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: UserStatus.error, errorMessage: e.toString()),
      );
    }
  }
}

enum UserStatus { initial, loading, loaded, error }
