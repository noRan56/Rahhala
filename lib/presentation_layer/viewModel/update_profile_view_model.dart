import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/widgets/app_text_field.dart';
import 'package:travel_app/core/widgets/height_sized_box.dart';
import 'package:travel_app/data/cubit/user_cubit.dart';

class UpdateProfileViewModel extends StatefulWidget {
  const UpdateProfileViewModel({super.key});

  @override
  State<UpdateProfileViewModel> createState() => _UpdateProfileViewModelState();
}

class _UpdateProfileViewModelState extends State<UpdateProfileViewModel> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      
      ],
    );
  }
}
