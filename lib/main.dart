import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wellbeing_app_2/account_setup/login_screen.dart';
import 'package:wellbeing_app_2/firebase_options.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/screens/loading_screen.dart';
import 'package:wellbeing_app_2/student_account/student_home_screen.dart';
import 'package:wellbeing_app_2/teacher_account/teacher_home_screen.dart';
import 'package:wellbeing_app_2/userId.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WellbeingApp());
}

class WellbeingApp extends StatelessWidget {
  const WellbeingApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Wellbeing App',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // Check whether the Account Type is Student or Teacher
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingScreen();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    if (userData['Account Type'] == 'Student') {
                      return StudentHomeScreen(userData: userData);
                    }
                    if (userData['Account Type'] == 'Teacher') {
                      return TeacherHomeScreen(userData);
                    }
                  }
                  return const ErrorScreen();
                },
              );
            }
            return const LoginScreen();
          }
          return const ErrorScreen();
        },
      ),
    );
  }
}
