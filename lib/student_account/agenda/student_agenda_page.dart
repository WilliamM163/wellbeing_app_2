import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class StudentAgendaPage extends StatefulWidget {
  const StudentAgendaPage({super.key});

  @override
  State<StudentAgendaPage> createState() => _StudentAgendaPageState();
}

class _StudentAgendaPageState extends State<StudentAgendaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColour,
      body: const Center(child: Text('Student Agenda Page')),
    );
  }
}
