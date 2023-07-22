import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class StudentQuickLinksPage extends StatefulWidget {
  const StudentQuickLinksPage({super.key});

  @override
  State<StudentQuickLinksPage> createState() => _StudentQuickLinksPageState();
}

class _StudentQuickLinksPageState extends State<StudentQuickLinksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColour,
      body: const Center(child: Text('Student Quick Links')),
    );
  }
}
