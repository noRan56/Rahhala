import 'package:supabase_flutter/supabase_flutter.dart';

class CityPosts {
  final String cityName;
  final SupabaseClient supabase;

  CityPosts({required this.cityName, required this.supabase});

  Future<List<Map<String, dynamic>>> fetchPostsByCity() async {
    final response = await supabase
        .from('posts')
        .select()
        .eq('city_name', cityName)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
