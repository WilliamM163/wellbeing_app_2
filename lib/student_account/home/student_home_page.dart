import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/student_account/home/graph/graph.dart';
import 'package:wellbeing_app_2/student_account/survey/student_survey_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData['Teacher Id'])
          .collection('quotes')
          .orderBy('Date')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        try {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<DocumentSnapshot> quoteList = snapshot.data!.docs;
            final int randomIndex = Random().nextInt(quoteList.length);
            final DocumentSnapshot quoteData = quoteList[randomIndex];

            return content(userData: widget.userData, quoteData: quoteData);
          }
        } catch (e) {
          return content(userData: widget.userData, quoteData: {
            'Quote': 'No quote, please ask your teacher to add some quotes',
            'Author': 'Taupānga Oranga',
          });
        }

        return const ErrorScreen();
      },
    );
  }

  Widget content({
    required Map<String, dynamic> userData,
    required quoteData,
  }) {
    final String firstName = userData['Name'].split(' ')[0];
    return Padding(
      padding: AppStyle.appPadding,
      child: Column(
        children: [
          _quoteContainer(firstName, quoteData),
          const SizedBox(height: 10),
          _graph(),
          const SizedBox(height: 10),
          _requestToTalk(),
          _startSurvey(userData)
        ],
      ),
    );
  }

  Widget _requestToTalk() {
    bool isLoading = false;

    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isLoading == false
              ? () {
                  setState(() => isLoading = !isLoading);
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userData['Teacher Id'])
                      .get()
                      .then((value) {
                    launchUrlString(
                      'mailto:${value['Email']}?subject=Request to Talk | Taupānga Oranga',
                    );
                    setState(() => isLoading = !isLoading);
                  });
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[800],
            foregroundColor: Colors.white,
          ),
          icon: !isLoading
              ? const Icon(Icons.email_rounded)
              : const CircularProgressIndicator(),
          label: Text(
            'Request to talk',
            style: AppStyle.defaultText,
          ),
        ),
      );
    });
  }

  SizedBox _startSurvey(Map<String, dynamic> userData) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentSurveyScreen(userData)),
          );
        },
        icon: const Icon(Icons.start_rounded),
        label: Text(
          'Start a survey',
          style: AppStyle.defaultText,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[800],
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _graph() {
    return StatefulBuilder(
      builder: (context, setState) => Expanded(
        child: CustomContainer(
          Container(
            width: double.infinity,
            padding: AppStyle.appPadding,
            child: const LineChartSample1(),
          ),
        ),
      ),
    );
  }

  CustomContainer _quoteContainer(String firstName, quoteData) {
    return CustomContainer(
      Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wellcome $firstName 👋',
              style: AppStyle.tileTitle,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '"${quoteData['Quote']}"',
                style: AppStyle.defaultText,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                quoteData['Author'] ?? 'Anonymous',
                style: AppStyle.defaultText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
