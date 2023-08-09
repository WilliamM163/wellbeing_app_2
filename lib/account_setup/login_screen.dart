import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/account_setup/signup_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/login_style.dart';

// In Flutter, a stateful widget is a type of widget that can change and
// maintain its internal state over time, allowing it to dynamically update and
// display different content in response to user interactions or changes in data.

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: AppStyle.appPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login', style: LoginStyle.mainTitle),
            const SizedBox(height: 10),
            Text('Please log in to continue', style: LoginStyle.description),
            const SizedBox(height: 10),

            //email
            TextField(
              decoration: LoginStyle.emailTextField,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              onChanged: (value) => _email = value,
            ),
            const SizedBox(height: 10),

            //password
            TextField(
              decoration: LoginStyle.passwordTextField,
              obscureText: true,
              onChanged: (value) => _password = value,
            ),
            const SizedBox(height: 10),

            //login button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isLoading) const CircularProgressIndicator(),
                if (_isLoading) const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _login,
                  icon: const Icon(Icons.done),
                  label: Text('LOGIN', style: AppStyle.defaultText),
                ),
              ],
            ),
            const SizedBox(height: 10),

            //create an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: LoginStyle.description,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Text('Sign up', style: LoginStyle.description),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    setState(() {
      _isLoading = !_isLoading;
    });

    _authenticate(_email, _password);
  }

  void _authenticate(email, password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        // ignore: body_might_complete_normally_catch_error
        .catchError((error) {
      String errorMessage = error.message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }
}
