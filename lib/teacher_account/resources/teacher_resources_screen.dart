import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';

class TeacherResourcesScreen extends StatelessWidget {
  const TeacherResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Resources'),
      backgroundColor: AppStyle.backgroundColour,
      body: Center(
        child: Text(
          'Sorry, this feature has not been implemented yet',
          style: AppStyle.mainTitle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
