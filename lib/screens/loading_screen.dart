import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: CircularProgressIndicator()),
      backgroundColor: AppStyle.backgroundColour,
    );
  }
}
