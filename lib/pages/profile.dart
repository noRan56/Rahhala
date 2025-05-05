import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/components/app_arrow_back.dart';
import 'package:travel_app/components/app_text.dart';
import 'package:travel_app/components/app_text_field.dart';
import 'package:travel_app/components/height_sized_box.dart';
import 'package:travel_app/models/data/cubit/user_cubit.dart';
import 'package:travel_app/models/data/cubit/user_state.dart';
import 'package:travel_app/models/model/shared_perferences.dart';
import 'dart:io';

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

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response =
          await supabase.from('users').select().eq('id', userId).maybeSingle();

      if (response != null) {
        setState(() {
          _usernameController.text = response['username'] ?? '';
          _userImageUrl = response['image'];
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
    final userId = supabase.auth.currentUser?.id;
    final newUsername = _usernameController.text.trim();

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username cannot be empty')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload image
      String? imageUrl = _userImageUrl;
      if (_selectedImage != null) {
        final imageBytes = await _selectedImage!.readAsBytes();
        final imagePath =
            'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

        await supabase.storage
            .from('profile-pictures')
            .uploadBinary(imagePath, imageBytes);

        imageUrl = supabase.storage
            .from('profile-pictures')
            .getPublicUrl(imagePath);
      }

      // Update Supabase
      await supabase.from('users').upsert({
        'id': userId,
        'username': newUsername,
        'image': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Update local storage
      await SharedPerferencesHelper.saveUserName(newUsername);
      if (imageUrl != null) {
        await SharedPerferencesHelper.saveUserImage(imageUrl);
      }

      // 🔄 Update Bloc (UserCubit)
      context.read<UserCubit>().updateUser(newUsername, imageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      setState(() {
        _userImageUrl = imageUrl;
        _selectedImage = null;
      });
    } catch (e) {
      debugPrint('Failed to update profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        return SafeArea(
          child: Scaffold(
            body:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
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

                            /// 👇 بدل من: AppText(text: _usernameController.text),
                            AppText(text: userState.username ?? ''),

                            AppTextField(
                              hintText: 'Username',
                              controller: _usernameController,
                              maxLine: 1,
                            ),
                            MySizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50.h),
                              ),
                              child: const Text('Update Profile'),
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
