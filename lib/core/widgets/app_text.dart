// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  double? size = 20;
  Color? color = Colors.black;
  AppText({Key? key, required this.text, this.size, this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
