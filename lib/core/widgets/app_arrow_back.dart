import 'package:flutter/material.dart';

class AppArrowBack extends StatelessWidget {
  const AppArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
    );
  }
}
