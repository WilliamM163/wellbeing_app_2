import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/student_account/survey/survey.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/userId.dart';

class StudentSurveyScreen extends StatelessWidget {
  const StudentSurveyScreen(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Surveys'),
      backgroundColor: AppStyle.backgroundColour,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userData['Teacher Id'])
            .collection('surveys')
            .orderBy('Date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            List surveys = snapshot.data!.docs;
            if (surveys.isEmpty) {
              return _noSurveys();
            }
            return _surveyList(context, surveys);
          }
          return const ErrorScreen();
        },
      ),
    );
  }

  Padding _surveyList(BuildContext context, List<dynamic> surveys) {
    return Padding(
      padding: AppStyle.appPadding,
      child: ListView.builder(
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          bool isDone = false;
          try {
            isDone = surveys[index]['Done'][userId];
          } catch (e) {
            null;
          }
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: isDone
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyScreen(
                              survey: surveys[index],
                              userData: userData,
                            ),
                          ),
                        );
                      },
                child: CustomContainer(
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.assignment_rounded),
                    ),
                    title: Text(
                      surveys[index]['Title'],
                      style: AppStyle.tileTitle,
                    ),
                    trailing: isDone
                        ? Icon(
                            Icons.done_rounded,
                            color: Colors.green[800],
                          )
                        : Icon(
                            Icons.horizontal_rule_rounded,
                            color: Colors.red[800],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Center _noSurveys() {
    return Center(
      child: Text(
        'No surveys to do, ask your teacher to make some surveys',
        style: AppStyle.defaultText,
        textAlign: TextAlign.center,
      ),
    );
  }

  Center _loading() => const Center(child: CircularProgressIndicator());
}
