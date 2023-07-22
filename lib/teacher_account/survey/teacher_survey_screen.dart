// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/teacher_account/survey/create_survey_screen.dart';
import 'package:wellbeing_app_2/userId.dart';

// ignore: must_be_immutable
class TeacherSurveyScreen extends StatelessWidget {
  TeacherSurveyScreen({super.key});
  String? title;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('surveys')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loading(context);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isEmpty) {
            return _noSurveys(context);
          }
        }
        return const ErrorScreen();
      },
    );
  }

  Widget _loading(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Surveys'),
      backgroundColor: AppStyle.backgroundColour,
      body: Center(child: Text('Loading ...', style: AppStyle.defaultText)),
    );
  }

  Widget _noSurveys(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Surveys'),
      backgroundColor: AppStyle.backgroundColour,
      body: Center(
        child: Text(
          'No surveys, please create a survey',
          style: AppStyle.defaultText,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _createSurveyTitle(context);
          if (title != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateSurveyScreen(title!)),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: Text('Create Survey', style: AppStyle.defaultText),
      ),
    );
  }

  Future<void> _createSurveyTitle(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create Survey',
            style: AppStyle.defaultText.copyWith(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            decoration: const InputDecoration(
              icon: Icon(Icons.text_fields),
              label: Text('Enter Title'),
            ),
            onChanged: (value) {
              title = value;
            },
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                if (title == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a title')),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.navigate_next_rounded),
              label: Text(
                'Start',
                style: AppStyle.defaultText,
              ),
            ),
          ],
        );
      },
    );
  }
}
