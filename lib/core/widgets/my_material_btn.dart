import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyMaterialBtn extends StatelessWidget {
  final String ImagePath;
  const MyMaterialBtn({super.key, required this.ImagePath});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(25),
      elevation: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset(
          ImagePath,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
