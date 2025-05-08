import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySizedBox extends StatelessWidget {
  final double height;

  const MySizedBox({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.h);
  }
}
