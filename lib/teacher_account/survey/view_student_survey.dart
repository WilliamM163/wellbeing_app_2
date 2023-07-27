import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/userId.dart';

class ViewStudentSurveyScreen extends StatelessWidget {
  const ViewStudentSurveyScreen({
    super.key,
    required this.title,
    required this.surveyId,
    required this.studentId,
  });
  final String title;
  final String surveyId;
  final String studentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title),
      backgroundColor: AppStyle.backgroundColour,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('surveys')
            .doc(surveyId)
            .collection('answers')
            .doc(studentId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(
              snapshot.data!.data().toString(),
              style: AppStyle.defaultText,
            );
          }
          return const ErrorScreen();
        },
      ),
    );
  }
}
