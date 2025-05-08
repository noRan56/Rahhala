import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:travel_app/core/widgets/app_arrow_back.dart';
import 'package:travel_app/core/widgets/app_text.dart';
import 'package:travel_app/core/widgets/loading.dart';
import 'package:travel_app/core/widgets/post_item.dart';
import 'package:travel_app/presentation_layer/view/top_pleces_view.dart';

class CityPostsPage extends StatelessWidget {
  final String cityName;
  final SupabaseClient supabase;

  const CityPostsPage({
    required this.cityName,
    required this.supabase,
    Key? key,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchPostsByCity() async {
    final response = await supabase
        .from('posts')
        .select()
        .ilike('place_name', cityName)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => TopPleces()),
                      );
                    },
                    child: AppArrowBack(),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 3.9),
                  AppText(text: cityName, color: Colors.blue, size: 28.sp),
                ],
              ),
              SizedBox(height: 20.h),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchPostsByCity(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final posts = snapshot.data!;
                  if (posts.isEmpty) {
                    return const Center(
                      child: Text('No posts found for this city.'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostItem(post: post, userId: '');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
