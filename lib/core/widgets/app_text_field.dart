// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  int? maxLine = 1;
  AppTextField({
    Key? key,
    required this.hintText,
    this.maxLine,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,

        cursorColor: Colors.white,
        maxLines: maxLine,

        decoration: InputDecoration(
          hintText: hintText,

          border: InputBorder.none,
          hintStyle: TextStyle(
            fontFamily: 'Lato',
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
