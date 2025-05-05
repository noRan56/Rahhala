import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/components/app_text.dart';

class MyTopContainer extends StatelessWidget {
  final String text;
  final String image;
  const MyTopContainer({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 160.w,
        height: 290.h,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/$image',
                fit: BoxFit.cover,
                width: 200.w,
                height: 300.h,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 250),
              height: 60.h,
              width: 200.w,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(child: AppText(text: text, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
