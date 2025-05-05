import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/models/data/cubit/post_cubit.dart';
import 'package:travel_app/models/data/cubit/user_cubit.dart';
import 'package:travel_app/pages/home.dart';
import 'package:travel_app/pages/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xvdvxwwlzrmwnrkerujg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2ZHZ4d3dsenJtd25ya2VydWpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUyMjc3NjAsImV4cCI6MjA2MDgwMzc2MH0.pFTUzi_6FV8gk5zjuemOKcD5gzgdrVsyWLkaIyaZ2xk',
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => PostCubit(Supabase.instance.client)),
        // Add other cubits as needed
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
