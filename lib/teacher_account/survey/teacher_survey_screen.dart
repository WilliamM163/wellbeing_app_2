// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/teacher_account/survey/create_survey_screen.dart';
import 'package:wellbeing_app_2/userId.dart';

// ignore: must_be_immutable
class TeacherSurveyScreen extends StatelessWidget {
  TeacherSurveyScreen(this.userData, {super.key});
  String? title;
  Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('surveys')
          .orderBy('Date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loading(context);
        }
        if (snapshot.connectionState == ConnectionState.active) {
          List surveys = snapshot.data!.docs;
          if (surveys.isEmpty) {
            return _noSurveys(context);
          }
          return surveyList(context, surveys);
        }
        return const ErrorScreen();
      },
    );
  }

  Scaffold surveyList(BuildContext context, List<dynamic> surveys) {
    return Scaffold(
      appBar: customAppBar(context, 'Surveys'),
      backgroundColor: AppStyle.backgroundColour,
      body: Padding(
        padding: AppStyle.appPadding,
        child: ListView.builder(
          itemCount: surveys.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                CustomContainer(ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.assignment_rounded),
                  ),
                  title: Text(
                    surveys[index]['Title'],
                    style: AppStyle.tileTitle,
                  ),
                  trailing: InkWell(
                    onTap: () {
                      _deleteSurvey(surveys[index].id);
                    },
                    child: const Icon(Icons.delete_rounded),
                  ),
                )),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
      floatingActionButton: fab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _deleteSurvey(String surveyID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('surveys')
        .doc(surveyID)
        .delete();
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
      floatingActionButton: fab(context),
    );
  }

  FloatingActionButton fab(BuildContext context) {
    return FloatingActionButton.extended(
      foregroundColor: Colors.white,
      backgroundColor: Colors.grey.shade900,
      onPressed: () async {
        await _createSurveyTitle(context);
        if (title != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateSurveyScreen(title!, userData: userData),
            ),
          );
        }
      },
      icon: const Icon(Icons.add),
      label: Text('Create Survey', style: AppStyle.defaultText),
    );
  }

  Future<void> _createSurveyTitle(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: AppStyle.containerColour,
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
