import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/widgets/app_arrow_back.dart';
import 'package:travel_app/core/widgets/app_text.dart';

import 'package:travel_app/core/widgets/height_sized_box.dart';
import 'package:travel_app/core/widgets/top_places.dart';

import 'package:travel_app/presentation_layer/view/city_posts_page.dart';
import 'package:travel_app/presentation_layer/view/home_view.dart';

class TopPleces extends StatelessWidget {
  const TopPleces({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 15.h, left: 20.w),
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
                  MyTopContainer(
                    image: 'makka.jpg',
                    text: 'Makka',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'Makka',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  MyTopContainer(
                    image: 'dubai.jpg',
                    text: 'Dubai',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'Dubai',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              MySizedBox(height: 15),
              Row(
                children: [
                  // Luxor
                  MyTopContainer(
                    image: 'luxor.jpg',
                    text: 'Luxor',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'Luxor',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  MyTopContainer(
                    image: 'bali.jpg',
                    text: 'Bali',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'Bali',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              MySizedBox(height: 15),
              Row(
                children: [
                  MyTopContainer(
                    image: 'france.jpg',
                    text: 'France',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'France',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  MyTopContainer(
                    image: 'india.jpg',
                    text: 'India',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'India',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              MySizedBox(height: 15),
              Row(
                children: [
                  MyTopContainer(
                    image: 'cairo.jpg',
                    text: 'Cairo',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'Cairo',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  MyTopContainer(
                    image: 'malsia.jpg',
                    text: 'Malaysia',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'Malaysia',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              MySizedBox(height: 15),
              Row(
                children: [
                  MyTopContainer(
                    image: 'newyork.jpg',
                    text: 'New York',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'New York',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  MyTopContainer(
                    image: 'tajmahal.jpg',
                    text: 'Taj Mahal',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CityPostsPage(
                                cityName: 'Taj Mahal',
                                supabase: Supabase.instance.client,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
