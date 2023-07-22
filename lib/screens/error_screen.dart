import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Whoops, something went wrong',
          textAlign: TextAlign.center,
          style: AppStyle.defaultText,
        ),
      ),
      backgroundColor: AppStyle.backgroundColour,
    );
  }
}
