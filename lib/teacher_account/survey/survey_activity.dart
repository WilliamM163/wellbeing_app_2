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
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.active) {
                      final Map<String, dynamic>? students =
                          snapshot.data!.data()!['Done'];
                      Map<String, dynamic>? hasRead =
                          snapshot.data!.data()!['Has Read'];
                      hasRead ??= {};
                      // ignore: unnecessary_null_comparison
                      if (students == null) {
                        return Center(
                          child: Text(
                            'No one has completed the survey',
                            style: AppStyle.defaultText,
                          ),
                        );
                      }
                      List<String> studentsList = students.keys.toList();

                      return ListView.builder(
                        itemCount: studentsList.length,
                        itemBuilder: (context, index) {
                          String studentId = studentsList[index];
                          return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(studentId)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _listTile(
                                    title: '...', hasRead: hasRead![studentId]);
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                String studentName = snapshot.data!['Name'];
                                String? avatar = snapshot.data!['Avatar'];
                                return _listTile(
                                  title: studentName,
                                  studentId: studentId,
                                  surveyId: widget.surveyId,
                                  hasRead: hasRead![studentId],
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
                  }),
            ),
            const Divider(),
            Text(
              'Students who haven\'t completed their survey',
              style: AppStyle.mainTitle.copyWith(fontSize: 18),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Column _listTile({
    required String title,
    String? surveyId,
    String? studentId,
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
              trailing: hasRead != null
                  ? const Icon(Icons.done)
                  : const Icon(Icons.horizontal_rule_rounded),
            ),
          ),
        )
      ],
    );
  }
}
