import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/widgets/app_text.dart';
import 'package:travel_app/core/widgets/height_sized_box.dart';
import 'package:travel_app/core/widgets/loading.dart';
import 'package:travel_app/core/widgets/my_material_btn.dart';
import 'package:travel_app/core/widgets/post_item.dart';
import 'package:travel_app/data/cubit/user_cubit.dart';
import 'package:travel_app/data/cubit/user_state.dart';
import 'package:travel_app/data/repositories/database.dart';
import 'package:travel_app/data/repositories/shared_perferences.dart';
import 'package:travel_app/presentation_layer/view/add_post_view.dart';
import 'package:travel_app/presentation_layer/view/profile_view.dart';
import 'package:travel_app/presentation_layer/view/top_pleces_view.dart';
import 'package:travel_app/presentation_layer/widgets/all_posts_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<List<Map<String, dynamic>>>? postStream;
  getAllPosts() async {
    postStream = await DataBaseHelper().getPosts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/home.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 45.h,
                        left: 20.w,
                        right: 20.w,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const TopPleces(),
                                ),
                              );
                            },
                            child: MyMaterialBtn(
                              ImagePath: 'assets/images/pin.png',
                            ),
                          ),

                          Spacer(),
                          Material(
                            borderRadius: BorderRadius.circular(16),
                            elevation: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const PostPage(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add, color: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Profile(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  (userState.imageUrl != null
                                      ? NetworkImage(userState.imageUrl!)
                                      : AssetImage('assets/images/user.png')
                                          as ImageProvider),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100, left: 20),
                      child: Column(
                        children: [
                          AppText(
                            text: 'Travelers ',
                            size: 40,
                            color: Colors.white,
                          ),
                          AppText(
                            text: 'Travel Community App ',
                            size: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.7,
                        left: MediaQuery.of(context).size.width / 15,
                        right: MediaQuery.of(context).size.width / 15,
                      ),

                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: TextField(
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black),

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search),
                              hintText: 'Search for Your Destination 🎯 ',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.sp,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                MySizedBox(height: 30),
                allPosts(postStream),
              ],
            ),
          );
        },
      ),
    );
  }
}
