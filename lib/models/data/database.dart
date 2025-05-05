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

    // Initial fetch
    _fetchPosts().then((posts) {
      controller.add(posts);
    });

    // Set up realtime subscription
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

  Future<void> addLike(String postId, String userId) async {
    try {
      // Check if user already liked this post
      final existingLike =
          await supabase
              .from('posts')
              .select()
              .eq('like_id', postId)
              .eq('user_id', userId)
              .maybeSingle();

      if (existingLike != null) {
        // User already liked - remove like
        await supabase
            .from('posts')
            .delete()
            .eq('like_id', postId)
            .eq('user_id', userId);
      } else {
        // Add new like
        await supabase.from('posts').insert({
          'like_id': postId,
          'user_id': userId,
        });
      }

      // Get updated like count (corrected Supabase count syntax)
    } catch (e) {
      throw Exception('Failed to update like: $e');
    }
  }
}
