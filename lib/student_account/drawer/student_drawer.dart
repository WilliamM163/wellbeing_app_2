import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyle.drawerColour,
    );
  }
}
