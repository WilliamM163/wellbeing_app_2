import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/teacher_account/survey/question.dart';

class CreateSurveyScreen extends StatefulWidget {
  const CreateSurveyScreen(this.title, {super.key});
  final String title;

  @override
  State<CreateSurveyScreen> createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> questions = [
      {
        'Question': 'How does it feel to lick my balls?',
        'Further Question': 'Why do you think that?'
      },
      {
        'Question': 'How does it feel to kill yourself?',
        'Further Question': 'How do you know?'
      },
      {
        'Question': 'How would you rate your mum?',
        'Further Question': null,
      },
    ];

    return Scaffold(
      appBar: _appBar(context, widget.title),
      backgroundColor: AppStyle.backgroundColour,
      body: Padding(
        padding: AppStyle.appPadding,
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Question(
              index: index,
              question: questions[index]['Question'],
              furtherQuestion: questions[index]['Further Question'],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          'Add a question',
          style: AppStyle.defaultText,
        ),
        icon: const Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade900,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: 80,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppStyle.appBarColour,
      title: Row(
        children: [
          InkWell(
            onTap: _exitSurvey,
            child: const Icon(
              Icons.close_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(child: Text(title, style: AppStyle.mainTitle)),
        ],
      ),
    );
  }

  Future<void> _exitSurvey() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: AppStyle.containerColour,
          title: Text(
            'Are you sure you want to exit?',
            style: AppStyle.defaultText,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
                style: AppStyle.defaultText,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Yes',
                style: AppStyle.defaultText,
              ),
            ),
          ],
        );
      },
    );
  }
}
