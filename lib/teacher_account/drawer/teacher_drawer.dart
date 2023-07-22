import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyle.drawerColour,
    );
  }
}
