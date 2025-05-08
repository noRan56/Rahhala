import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:travel_app/core/widgets/app_arrow_back.dart';
import 'package:travel_app/core/widgets/app_text.dart';
import 'package:travel_app/core/widgets/app_text_field.dart';
import 'package:travel_app/core/widgets/height_sized_box.dart';
import 'package:travel_app/core/widgets/loading.dart';
import 'package:travel_app/data/cubit/user_cubit.dart';
import 'package:travel_app/data/cubit/user_state.dart';
import 'package:travel_app/data/repositories/shared_perferences.dart';
import 'dart:io';

import 'package:travel_app/presentation_layer/view/sign_up_view.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _usernameController;
  File? _selectedImage;
  String? _userImageUrl;
  bool _isLoading = false;

  Future<void> signOutUser() async {
    await Supabase.instance.client.auth.signOut();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false,
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateProfile() async {
    final newUsername = _usernameController.text.trim();

    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username cannot be empty')));
      return;
    }

    context.read<UserCubit>().updateProfile(
      username: newUsername,
      imageFile: _selectedImage,
    );

    setState(() => _selectedImage = _selectedImage);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    context.read<UserCubit>().loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        return SafeArea(
          child: Scaffold(
            body:
                _isLoading
                    ? Loading()
                    : SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppArrowBack(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 4.9,
                                ),
                                AppText(
                                  text: 'Profile',
                                  color: Colors.blue,
                                  size: 28.sp,
                                ),
                              ],
                            ),
                            MySizedBox(height: 20),

                            GestureDetector(
                              onTap: _pickImage,
                              child: Center(
                                child: Container(
                                  width: 150.w,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                    image:
                                        _selectedImage != null ||
                                                userState.imageUrl != null
                                            ? DecorationImage(
                                              image:
                                                  _selectedImage != null
                                                      ? FileImage(
                                                        _selectedImage!,
                                                      )
                                                      : NetworkImage(
                                                            userState.imageUrl!,
                                                          )
                                                          as ImageProvider,
                                              fit: BoxFit.cover,
                                            )
                                            : null,
                                  ),
                                  child:
                                      _selectedImage == null &&
                                              userState.imageUrl == null
                                          ? const Icon(Icons.person, size: 50)
                                          : null,
                                ),
                              ),
                            ),
                            MySizedBox(height: 20),

                            AppText(text: userState.username ?? ''),

                            AppTextField(
                              hintText: 'Username',
                              controller: _usernameController,
                              maxLine: 1,
                            ),
                            MySizedBox(height: 20),

                            GestureDetector(
                              onTap: _updateProfile,
                              child: Container(
                                padding: EdgeInsets.all(10.h.w),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: AppText(
                                  text: 'Update Profile',
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: signOutUser,
                              child: Container(
                                padding: EdgeInsets.all(10.h.w),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: AppText(
                                  text: 'Sign Out',
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        );
      },
    );
  }
}
