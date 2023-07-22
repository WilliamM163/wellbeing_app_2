import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/userId.dart';

class TeacherAccountInfoScreen extends StatefulWidget {
  const TeacherAccountInfoScreen(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  State<TeacherAccountInfoScreen> createState() =>
      _TeacherAccountInfoScreenState();
}

class _TeacherAccountInfoScreenState extends State<TeacherAccountInfoScreen> {
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
            appBar: customAppBar(context, 'Account Information'),
            backgroundColor: AppStyle.backgroundColour,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          List students = snapshot.data!.docs;
          return Scaffold(
            appBar: customAppBar(context, 'Account Information'),
            body: Padding(
              padding: AppStyle.appPadding,
              child: Column(
                children: [
                  CustomContainer(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (widget.userData['Avatar'] != null)
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(widget.userData['Avatar']),
                                  ),
                                if (widget.userData['Avatar'] == null)
                                  const Icon(
                                    Icons.account_circle_rounded,
                                    size: 80,
                                  ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.userData['Name'],
                                      style: AppStyle.defaultText.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      widget.userData['Email'],
                                      style: AppStyle.defaultText,
                                      overflow: TextOverflow.clip,
                                    ),
                                    Text(
                                      'School: ${widget.userData['School']}',
                                      style: AppStyle.defaultText,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Students',
                    style: AppStyle.defaultText.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return CustomContainer(
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  if (students[index]['Avatar'] != null)
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        students[index]['Avatar'],
                                      ),
                                    ),
                                  if (students[index]['Avatar'] == null)
                                    const Icon(
                                      Icons.account_circle_rounded,
                                      size: 80,
                                    ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            students[index]['Name'],
                                            style:
                                                AppStyle.defaultText.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            students[index]['Email'],
                                            style:
                                                AppStyle.defaultText.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Feature has not been implemented yet'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_rounded),
                        label: Text(
                          'Edit Account Details',
                          style: AppStyle.defaultText,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: Text(
                          'Log Out',
                          style: AppStyle.defaultText,
                        ),
                      ),
                    ],
                  )
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

  void _copyToClipBoard() async {
    await Clipboard.setData(ClipboardData(text: userId));
  }
}
