import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';

class StudentAccountInfoScreen extends StatefulWidget {
  const StudentAccountInfoScreen(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  State<StudentAccountInfoScreen> createState() =>
      _StudentAccountInfoScreenState();
}

class _StudentAccountInfoScreenState extends State<StudentAccountInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userData['Teacher Id'])
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: customAppBar(context, 'Account Information'),
              backgroundColor: AppStyle.backgroundColour,
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: customAppBar(context, 'Account Information'),
              body: Padding(
                padding: AppStyle.appPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Account',
                      style: AppStyle.defaultText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Divider(),
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
                                      backgroundImage: NetworkImage(
                                          widget.userData['Avatar']),
                                    ),
                                  if (widget.userData['Avatar'] == null)
                                    const Icon(
                                      Icons.account_circle_rounded,
                                      size: 80,
                                    ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    const SizedBox(height: 10),
                    Text(
                      'Your Teacher',
                      style: AppStyle.defaultText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Divider(),
                    CustomContainer(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (snapshot.data!['Avatar'] != null)
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(snapshot.data!['Avatar']),
                                  ),
                                if (snapshot.data!['Avatar'] == null)
                                  const Icon(
                                    Icons.account_circle_rounded,
                                    size: 80,
                                  ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!['Name'],
                                      style: AppStyle.defaultText.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!['Email'],
                                      style: AppStyle.defaultText,
                                      overflow: TextOverflow.fade,
                                    ),
                                    Text(
                                      'School: ${snapshot.data!['School']}',
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
                    Expanded(child: Container()),
                    Text(
                      'All information stored in your account stays private. This excludes the survey, which your responses is sent to your teacher, and only your teacher. This also excludes the statistic of how many tasks you have done.',
                      style: AppStyle.description,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Feature has not been implemented yet'),
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
        });
  }
}
