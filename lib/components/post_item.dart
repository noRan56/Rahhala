import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/components/app_text.dart';
import 'package:travel_app/models/data/cubit/user_cubit.dart';
import 'package:travel_app/models/data/cubit/user_state.dart';
import 'package:travel_app/models/data/database.dart';
import 'package:travel_app/models/model/shared_perferences.dart';
import 'package:travel_app/pages/comments.dart';

class PostItem extends StatefulWidget {
  final Map<String, dynamic> post;
  final String userId;

  const PostItem({super.key, required this.post, required this.userId});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isLiked = false;

  @override
  void initState() {
    checkIfLiked();

    super.initState();
  }

  Future<void> checkIfLiked() async {
    final supabase = Supabase.instance.client;

    final like =
        await supabase
            .from('posts')
            .select()
            .eq('user_id', widget.userId)
            .eq('id', widget.post['id'])
            .maybeSingle();
    print("Post is not liked");
    if (like != null) {
      setState(() {
        isLiked = true;
      });
    }
  }

  Future<void> toggleLike() async {
    final dbHelper = DataBaseHelper();
    try {
      await DataBaseHelper().addLike(widget.post['id'], widget.userId);
      setState(() {
        isLiked = !isLiked;
      });
    } catch (e, stack) {
      print('❌ Error toggling like: $e');
      print('📍 Stack: $stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Material(
        borderRadius: BorderRadius.circular(25),
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info row
              BlocBuilder<UserCubit, UserState>(
                builder: (context, userState) {
                  final isOwner = widget.post['user_id'] == widget.userId;

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            isOwner && userState.imageUrl != null
                                ? NetworkImage(userState.imageUrl!)
                                : (widget.post['image'] != null
                                    ? NetworkImage(widget.post['image'])
                                    : const AssetImage('assets/images/user.png')
                                        as ImageProvider),
                      ),
                      SizedBox(width: 10),
                      AppText(
                        text:
                            isOwner && userState.username != null
                                ? userState.username!
                                : widget.post['username'] ?? 'no user',
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),

              // Post image
              ClipRRect(
                child: SizedBox(
                  width: double.infinity, // Ensures full width
                  height: 200.h,
                  child: Image.network(
                    widget.post['image_url'],

                    // width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                (loadingProgress.expectedTotalBytes != null &&
                                        loadingProgress.expectedTotalBytes! > 0)
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Colors.blue),
                  SizedBox(width: 5),
                  AppText(
                    text:
                        '${widget.post['place_name']}, ${widget.post['city_name']}',
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Description
              AppText(
                text: widget.post['description'] ?? 'No description',
                size: 15,
              ),
              SizedBox(height: 10),

              // Like/comment buttons
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      try {
                        await DataBaseHelper().addLike(
                          widget.post['id'].toString(),
                          widget.userId,
                        );
                        setState(() {
                          isLiked = !isLiked;
                        });
                      } catch (e) {
                        print('❌ Error toggling like: $e');
                      }
                    },
                  ),

                  AppText(text: 'Like'),
                  SizedBox(width: 15),
                  IconButton(
                    icon: Icon(Icons.comment_outlined, size: 23),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Comments(),
                        ),
                      );
                    },
                  ),
                  AppText(text: 'Comment'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
