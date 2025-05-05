import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/models/data/cubit/user_state.dart';
import 'package:travel_app/models/data/database.dart';
import 'package:travel_app/models/model/shared_perferences.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final SupabaseClient supabase;

  PostCubit(this.supabase) : super(PostInitial());

  Future<void> createPost({
    required File image,
    required String placeName,
    required String description,
    required String location,
  }) async {
    emit(PostLoading());

    try {
      // 1. Get current user data
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      // 3. Upload image to Supabase Storage
      final imageBytes = await image.readAsBytes();
      final imagePath =
          'post_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('posts').uploadBinary(imagePath, imageBytes);
      final imageUrl = supabase.storage.from('posts').getPublicUrl(imagePath);

      // 4. Prepare post data
      final postData = {
        'image_url': imageUrl,
        'place_name': placeName,
        'description': description,
        'city_name': location,
        'image': imagePath,
        'username': SharedPerferencesHelper.getUserName(),

        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      // 5. Add post to posts table
      await supabase.from('posts').insert(postData);

      emit(PostSuccess());
    } catch (e) {
      emit(PostFailure(e.toString()));
    }
  }
}
