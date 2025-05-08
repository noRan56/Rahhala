import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/widgets/app_text.dart';

class MyTopContainer extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback? onTap;
  const MyTopContainer({
    super.key,
    required this.text,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }
}
