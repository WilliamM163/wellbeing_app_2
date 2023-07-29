import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/teacher_account/survey/view_student_survey.dart';
import 'package:wellbeing_app_2/userId.dart';

class SurveyActivityScreen extends StatefulWidget {
  const SurveyActivityScreen(this.userData, this.surveyId, {super.key});
  final Map<String, dynamic> userData;
  final String surveyId;

  @override
  State<SurveyActivityScreen> createState() => _SurveyActivityScreenState();
}

class _SurveyActivityScreenState extends State<SurveyActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Survey Activty'),
      backgroundColor: AppStyle.backgroundColour,
      body: Padding(
        padding: AppStyle.appPadding,
        child: Column(
          children: [
            Text(
              'Students who completed their survey',
              style: AppStyle.mainTitle.copyWith(fontSize: 18),
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('surveys')
                    .doc(widget.surveyId)
                    .collection('answers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.active) {
                    final List students = snapshot.data!.docs;

                    if (students.isEmpty) {
                      return Center(
                        child: Text(
                          'No one has completed the survey',
                          style: AppStyle.defaultText,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        String studentId = students[index].id;
                        bool? hasRead = students[index].data()!['Has Read'];
                        hasRead ??= false;
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(studentId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _listTile(title: '...', hasRead: hasRead);
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              String studentName = snapshot.data!['Name'];
                              String email = snapshot.data!['Email'];
                              String? avatar = snapshot.data!['Avatar'];
                              return _listTile(
                                title: studentName,
                                studentId: studentId,
                                email: email,
                                surveyId: widget.surveyId,
                                hasRead: hasRead,
                                avatar: avatar,
                              );
                            }
                            return _listTile(title: 'Error', hasRead: null);
                          },
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
            const Divider(),
            // Text(
            //   'Students who haven\'t completed their survey',
            //   style: AppStyle.mainTitle.copyWith(fontSize: 18),
            // ),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Column _listTile({
    required String title,
    String? surveyId,
    String? studentId,
    String? email,
    required bool? hasRead,
    String? avatar,
  }) {
    return Column(
      children: [
        CustomContainer(
          InkWell(
            onTap: surveyId == null && studentId == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewStudentSurveyScreen(
                          title: title,
                          surveyId: surveyId!,
                          studentId: studentId!,
                          email: email!,
                        ),
                      ),
                    );
                  },
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              leading: avatar == null
                  ? const Icon(
                      Icons.account_circle_rounded,
                      size: 40,
                    )
                  : CircleAvatar(backgroundImage: NetworkImage(avatar)),
              title: Text(
                title,
                style: AppStyle.defaultText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: hasRead!
                  ? Icon(
                      Icons.done,
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
  }
}
