// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/teacher_account/survey/question.dart';
import 'package:wellbeing_app_2/userId.dart';

class CreateSurveyScreen extends StatefulWidget {
  const CreateSurveyScreen(this.title, {super.key, required this.userData});
  final String title;
  final Map<String, dynamic> userData;

  @override
  State<CreateSurveyScreen> createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  List<Map<String, dynamic>>? questions;
  @override
  void initState() {
    questions = [
      {
        'Question':
            'With 10 being the best, how would your rate you overall wellbeing?',
        'Scale or Descriptor': 'Scale',
        'Indepth Question': 'Why is this the case?'
      },
      {
        'Question': 'List 5 things to be greatful for',
        'Scale or Descriptor': 'Descriptor',
        'Indepth Question': null,
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, widget.title),
      backgroundColor: AppStyle.backgroundColour,
      body: Padding(
        padding: AppStyle.appPadding,
        child: ListView.builder(
          itemCount: questions!.length,
          itemBuilder: (context, index) {
            return Question(
              index: index,
              questions: questions!,
              onDelete: () {
                setState(() {
                  questions!.removeAt(index);
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addQuestion,
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
          const SizedBox(width: 7),
          InkWell(
            onTap: _sendSurvey,
            child: const Icon(
              Icons.send_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
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

  Future<void> _addQuestion() {
    String? question;
    String scaleOrDescriptor = 'Scale';
    String? indepthQuestion;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppStyle.containerColour,
        surfaceTintColor: AppStyle.containerColour,
        title: Text(
          'Add a question',
          style: AppStyle.defaultText,
        ),
        content: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  label: Text(
                    '* Question',
                    style: AppStyle.defaultText,
                  ),
                ),
                onChanged: (value) => question = value,
              ),
              const SizedBox(height: 10),
              DropdownButton(
                value: scaleOrDescriptor,
                items: [
                  DropdownMenuItem(
                    value: 'Scale',
                    child: Text(
                      '* Scale',
                      style: AppStyle.defaultText,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Descriptor',
                    child: Text(
                      '* Descriptor',
                      style: AppStyle.defaultText,
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() => scaleOrDescriptor = value!);
                },
                dropdownColor: AppStyle.containerColour,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  label: Text(
                    'Indepth Question',
                    style: AppStyle.defaultText,
                  ),
                ),
                onChanged: (value) => indepthQuestion = value,
              ),
            ],
          );
        }),
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValid = confirmQuestion(question);
              if (isValid) {
                setState(
                  () {
                    questions = [
                      ...questions!,
                      {
                        'Question': question,
                        'Scale or Descriptor': scaleOrDescriptor,
                        'Indepth Question': indepthQuestion,
                      }
                    ];
                  },
                );
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.done),
            label: Text(
              'Submit',
              style: AppStyle.defaultText,
            ),
          )
        ],
      ),
    );
  }

  bool confirmQuestion(String? question) {
    if (question != null) {
      return true;
    }
    return false;
  }

  Future<void> _sendSurvey() {
    bool isSending = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppStyle.containerColour,
              surfaceTintColor: AppStyle.containerColour,
              title: Text(
                'Are you sure you want to send to your students?',
                style: AppStyle.defaultText,
              ),
              actions: [
                if (isSending == false)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: AppStyle.defaultText,
                    ),
                  ),
                if (isSending) const CircularProgressIndicator(),
                TextButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          setState(() => isSending = !isSending);
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('surveys')
                              .doc()
                              .set({
                            'Date': Timestamp.now(),
                            'Title': widget.title,
                            'Survey': questions,
                          });
                          await FirebaseFirestore.instance
                              .collection('notifications')
                              .doc()
                              .set({
                            'Title':
                                '${widget.userData['Name']} has sent you a survey to do',
                            'Body': widget.title,
                            'Topic ID': userId,
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                  child: Text(
                    'Yes',
                    style: AppStyle.defaultText,
                  ),
                )
              ],
            );
          });
        });
  }
}
