// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/userId.dart';

class ViewStudentSurveyScreen extends StatefulWidget {
  const ViewStudentSurveyScreen({
    super.key,
    required this.title,
    required this.surveyId,
    required this.studentId,
    required this.email,
  });
  final String title;
  final String surveyId;
  final String studentId;
  final String email;

  @override
  State<ViewStudentSurveyScreen> createState() =>
      _ViewStudentSurveyScreenState();
}

class _ViewStudentSurveyScreenState extends State<ViewStudentSurveyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, widget.title,
          action: IconButton(
              onPressed: () {
                launchUrlString(
                  'mailto:${widget.email}?subject=Taupānga Oranga Survey',
                );
              },
              icon: const Icon(Icons.email_rounded))),
      backgroundColor: AppStyle.backgroundColour,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('surveys')
            .doc(widget.surveyId)
            .collection('answers')
            .doc(widget.studentId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            int itemCount = snapshot.data!.data()!.length;
            if (snapshot.data!.data()!.containsKey('Has Read')) {
              itemCount--;
            }
            return Padding(
              padding: AppStyle.appPadding,
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) =>
                    _response(snapshot.data!.data()!, index.toString()),
              ),
            );
          }
          return const ErrorScreen();
        },
      ),
    );
  }

  Column _response(Map<String, dynamic> response, String index) {
    Color sliderRGBValue =
        _getColorFromSliderValue(response[index]['Slider Value']);

    return _answerTile(index, response, sliderRGBValue);
  }

  Column _answerTile(
      String index, Map<String, dynamic> response, Color sliderRGBValue) {
    return Column(
      children: [
        CustomContainer(Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 10,
                      child: Icon(
                        Icons.question_mark_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Question ${int.parse(index) + 1}',
                      style: AppStyle.defaultText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  response[index]['Question'],
                  style: AppStyle.defaultText,
                ),
                if (response[index]['Scale or Descriptor'] == 'Scale')
                  Column(
                    children: [
                      Slider(
                        value: response[index]['Slider Value'],
                        activeColor: sliderRGBValue,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label:
                            response[index]['Slider Value'].toInt().toString(),
                        onChanged: (_) {},
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.thumb_down_rounded, size: 15),
                              const SizedBox(width: 5),
                              Text(
                                'Poor',
                                style:
                                    AppStyle.defaultText.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.thumb_up_rounded, size: 15),
                              const SizedBox(width: 5),
                              Text(
                                'Great',
                                style:
                                    AppStyle.defaultText.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                if (response[index]['Scale or Descriptor'] == 'Descriptor')
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        response[index]['Answer'],
                        style: AppStyle.defaultText,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                if (response[index]['Indepth Question'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        response[index]['Indepth Question'],
                        style: AppStyle.defaultText,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        response[index]['Indepth Answer'],
                        style: AppStyle.defaultText,
                      )
                    ],
                  ),
              ],
            ))),
        const SizedBox(height: 10),
        if (int.parse(index) == response.length - 1)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _readResponse();
              },
              icon: const Icon(Icons.done_rounded),
              label: Text(
                'Read',
                style: AppStyle.defaultText,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[800],
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Color _getColorFromSliderValue(sliderValue) {
    final hue = (sliderValue / 10 * 120); // 0-120: red to green
    return HSVColor.fromAHSV(1.0, hue, 1.0, 0.7).toColor();
  }

  _readResponse() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sending ...',
          style: AppStyle.defaultText,
        ),
      ),
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('surveys')
        .doc(widget.surveyId)
        .collection('answers')
        .doc(widget.studentId)
        .update({'Has Read': true});
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sent',
          style: AppStyle.defaultText,
        ),
      ),
    );
    Navigator.pop(context);
  }
}
