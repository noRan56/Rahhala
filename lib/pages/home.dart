import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/components/app_text.dart';
import 'package:travel_app/components/height_sized_box.dart';
import 'package:travel_app/components/my_material_btn.dart';
import 'package:travel_app/components/post_item.dart';
import 'package:travel_app/models/data/cubit/user_cubit.dart';
import 'package:travel_app/models/data/cubit/user_state.dart';
import 'package:travel_app/models/data/database.dart';
import 'package:travel_app/models/model/shared_perferences.dart';
import 'package:travel_app/pages/post_page.dart';
import 'package:travel_app/pages/profile.dart';
import 'package:travel_app/pages/top_pleces.dart';

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

  Widget allPosts() {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: postStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: AppText(text: 'Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          // Use userState.username and userState.imageUrl where needed
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
                      padding: const EdgeInsets.only(
                        top: 45,
                        left: 20,
                        right: 20,
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
                                fontSize: 15,
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
                allPosts(),
              ],
            ),
          );
        },
      ),
    );
  }
}
