import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/widgets/app_arrow_back.dart';

import 'package:travel_app/core/widgets/app_text.dart';
import 'package:travel_app/core/widgets/app_text_field.dart';
import 'package:travel_app/core/widgets/height_sized_box.dart';
import 'package:travel_app/core/widgets/image_pick.dart';
import 'package:travel_app/core/widgets/loading.dart';
import 'package:travel_app/data/cubit/post_cubit.dart';
import 'package:travel_app/presentation_layer/view/home_view.dart';
// ... other imports remain the same ...

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final placeNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    placeNameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(text: 'Failed to pick image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(Supabase.instance.client),
      child: Scaffold(
        body: BlocConsumer<PostCubit, PostState>(
          listener: (context, state) {
            if (state is PostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: AppText(
                    text: 'Post Added Successfully',
                    color: Colors.white,
                  ),
                ),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()),
              );
            } else if (state is PostFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: AppText(
                    text: 'Failed to add post: ${state.error}',
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 35, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                            );
                          },
                          child: AppArrowBack(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4.9,
                        ),
                        AppText(
                          text: ' Add Post',
                          color: Colors.blue,
                          size: 28.sp,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.w, right: 20.w),
                      child: Column(
                        children: [
                          MySizedBox(height: 25),
                          _selectedImage != null
                              ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _selectedImage!,
                                    height: 180.h,
                                    width: 180.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                              : ImagePickMe(pickImage: _pickImage),
                          MySizedBox(height: 20),
                          AppTextField(
                            hintText: 'Place Name',
                            controller: placeNameController,
                          ),
                          MySizedBox(height: 10),
                          AppTextField(
                            hintText: 'City Name',
                            controller: locationController,
                          ),
                          MySizedBox(height: 10),
                          AppTextField(
                            hintText: 'Captions',
                            maxLine: 5,
                            controller: descriptionController,
                          ),
                          MySizedBox(height: 20),
                          state is PostLoading
                              ? Loading()
                              : GestureDetector(
                                onTap: () {
                                  if (_selectedImage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: AppText(
                                          text: 'Please select an image',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  if (placeNameController.text.isEmpty ||
                                      descriptionController.text.isEmpty ||
                                      locationController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: AppText(
                                          text: 'Please fill all fields',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<PostCubit>().createPost(
                                    image: _selectedImage!,
                                    placeName: placeNameController.text,
                                    description: descriptionController.text,
                                    location: locationController.text,
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: AppText(
                                      text: "Post",
                                      color: Colors.white,
                                      size: 25.sp,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
