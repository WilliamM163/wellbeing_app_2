import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class StudentJournalPage extends StatefulWidget {
  const StudentJournalPage({super.key});

  @override
  State<StudentJournalPage> createState() => _StudentJournalPageState();
}

class _StudentJournalPageState extends State<StudentJournalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColour,
      body: const Center(child: Text('Student Journal Page')),
    );
  }
}
