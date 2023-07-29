// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/student_account/survey/question.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/userId.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key, required this.survey, required this.userData});
  final DocumentSnapshot survey;
  final Map<String, dynamic> userData;

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  Map<String, dynamic>? answers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        widget.survey['Title'],
      ),
      backgroundColor: AppStyle.backgroundColour,
      body: Padding(
        padding: AppStyle.appPadding,
        child: ListView.builder(
          itemCount: widget.survey['Survey'].length,
          itemBuilder: (context, index) {
            return Column(children: [
              Question(
                index: index,
                questions: widget.survey['Survey'],
                onChanged: ({answer, indepthAnswer, sliderValue}) {
                  answers ??= {};
                  if (answers![index.toString()] == null) {
                    answers![index.toString()] = {
                      'Question': widget.survey['Survey'][index]['Question'],
                      'Answer': answers,
                      'Indepth Question': widget.survey['Survey'][index]
                          ['Indepth Question'],
                      'Indepth Answer': indepthAnswer,
                      'Slider Value': sliderValue,
                      'Scale or Descriptor': widget.survey['Survey'][index]
                          ['Scale or Descriptor']
                    };
                  }
                  answers![index.toString()]['Answer'] = answer;
                  answers![index.toString()]['Indepth Answer'] = indepthAnswer;
                  answers![index.toString()]['Slider Value'] = sliderValue;
                },
              ),
              if (widget.survey['Survey'].length - 1 == index)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      bool isValid = _confirmDetails();
                      if (!isValid) {
                        return;
                      }
                      _sendResponse().then((value) => Navigator.pop(context));
                    },
                    icon: const Icon(Icons.done_rounded),
                    label: Text(
                      'Submit Survey',
                      style: AppStyle.defaultText,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
                )
            ]);
          },
        ),
      ),
    );
  }

  bool _confirmDetails() {
    if (answers == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in the survey',
            style: AppStyle.defaultText,
          ),
        ),
      );
      return false;
    }
    if (widget.survey['Survey'].length != answers!.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill out all values',
            style: AppStyle.defaultText,
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _sendResponse() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'Sending ...',
      style: AppStyle.defaultText,
    )));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData['Teacher Id'])
        .collection('surveys')
        .doc(widget.survey.id)
        .collection('answers')
        .doc(userId)
        .set(answers!);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'Sent',
      style: AppStyle.defaultText,
    )));
  }
}
