// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/userId.dart';

class ManageStudentsScreen extends StatelessWidget {
  const ManageStudentsScreen(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('students')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: customAppBar(context, 'Manage Students'),
            backgroundColor: AppStyle.backgroundColour,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          List students = snapshot.data!.docs;
          return Scaffold(
            appBar: customAppBar(context, 'Manage Students'),
            body: Padding(
              padding: AppStyle.appPadding,
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          String studentId = students[index].id;
                          return _studentTile(studentId);
                        }),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'To add students send the code below to your student\'s. Student\'s will enter the code as a part of their account creation process',
                    style: AppStyle.defaultText,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: _copyToClipBoard,
                        icon: const Icon(Icons.copy_all_rounded),
                        label: Text(
                          'Copy Teacher ID',
                          style: AppStyle.defaultText,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          userId,
                          style: AppStyle.defaultText.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            backgroundColor: AppStyle.backgroundColour,
          );
        }
        return const ErrorScreen();
      },
    );
  }

  _studentTile(String studentId) {
    return CustomContainer(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(studentId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final DocumentSnapshot? student = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (student!['Avatar'] == null)
                      const Icon(
                        Icons.account_circle_rounded,
                        size: 80,
                      ),
                    if (student['Avatar'] != null)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          student['Avatar'],
                        ),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            student != null ? student['Name'] : '',
                            style: AppStyle.defaultText.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            student != null ? student['Email'] : '',
                            style: AppStyle.defaultText.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  void _copyToClipBoard() async {
    await Clipboard.setData(ClipboardData(text: userId));
  }
}
