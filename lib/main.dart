import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/constants/db_init.dart';
import 'package:travel_app/data/cubit/post_cubit.dart';
import 'package:travel_app/data/cubit/user_cubit.dart';
import 'package:travel_app/presentation_layer/view/home_view.dart';
import 'package:travel_app/presentation_layer/view/sign_up_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: DbInit.url,
    anonKey: DbInit.anonKey,
    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: true,
      //
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => PostCubit(Supabase.instance.client)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Travel App',
          home: Login(),
        );
      },
    );
  }
}
