import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/widgets/app_text.dart';
import 'package:travel_app/core/widgets/loading.dart';
import 'package:travel_app/core/widgets/post_item.dart';

Widget allPosts(Stream<List<Map<String, dynamic>>>? postStream) {
  final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: postStream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: AppText(text: 'Error: ${snapshot.error}'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Loading();
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: AppText(text: 'No posts found'));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final post = snapshot.data![index];
          return PostItem(post: post, userId: userId);
        },
      );
    },
  );
}
