import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/components/app_arrow_back.dart';
import 'package:travel_app/components/app_text.dart';
import 'package:travel_app/components/height_sized_box.dart';
import 'package:travel_app/components/top_places.dart';
import 'package:travel_app/pages/home.dart';

class TopPleces extends StatelessWidget {
  const TopPleces({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                    child: AppArrowBack(),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 4.9),
                  AppText(text: 'Top Places', color: Colors.blue, size: 28.sp),
                ],
              ),
              MySizedBox(height: 20),

              Row(
                children: [
                  MyTopContainer(image: 'makka.jpg', text: 'Makka'),
                  SizedBox(width: 10.w),
                  MyTopContainer(image: 'dubai.jpg', text: 'Dubai'),
                ],
              ),
              MySizedBox(height: 15),
              Row(
                children: [
                  // Luxor
                  MyTopContainer(image: 'luxor.jpg', text: 'Luxor'),
                  SizedBox(width: 10.w),
                  MyTopContainer(image: 'bali.jpg', text: 'Bali'),
                ],
              ),
              MySizedBox(height: 15),
              Row(
                children: [
                  MyTopContainer(image: 'france.jpg', text: 'France'),
                  SizedBox(width: 10.w),
                  MyTopContainer(image: 'india.jpg', text: 'India'),
                ],
              ),
              MySizedBox(height: 15),
              Row(
                children: [
                  MyTopContainer(image: 'cairo.jpg', text: 'Cairo'),
                  SizedBox(width: 10.w),
                  MyTopContainer(image: 'malsia.jpg', text: 'Malaysia'),
                ],
              ),
              MySizedBox(height: 15),
              Row(
                children: [
                  MyTopContainer(image: 'newyork.jpg', text: 'New York'),
                  SizedBox(width: 10.w),
                  MyTopContainer(image: 'tajmahal.jpg', text: 'Taj Mahal'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
