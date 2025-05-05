import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/components/app_arrow_back.dart';
import 'package:travel_app/components/app_text.dart';
import 'package:travel_app/pages/home.dart';

class Comments extends StatelessWidget {
  const Comments({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  child: AppArrowBack(),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 4.9),
                AppText(text: ' Add Post', color: Colors.blue, size: 28.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
