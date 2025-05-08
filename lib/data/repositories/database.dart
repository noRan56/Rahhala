import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class DataBaseHelper {
  final supabase = Supabase.instance.client;

  Future addUserDetails(Map<String, dynamic> data, String id) async {
    return await supabase.from('users').insert(data);
  }

  Future addPostDetails(Map<String, dynamic> data, String id) async {
    return await supabase.from('posts').insert(data);
  }

  Stream<List<Map<String, dynamic>>> getPosts() {
    // Create a stream controller to manage the stream
    final controller = StreamController<List<Map<String, dynamic>>>();

    _fetchPosts().then((posts) {
      controller.add(posts);
    });

    final subscription = supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen((data) {
          controller.add(data);
        });

    // Cancel subscription when stream is closed
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }

  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    final response = await supabase
        .from('posts')
        .select('*, users(username, image)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
