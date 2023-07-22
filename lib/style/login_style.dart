import 'package:flutter/material.dart';

import 'app_style.dart';

class LoginStyle {
  static TextStyle mainTitle = AppStyle.defaultText.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static TextStyle description = AppStyle.defaultText.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  static InputDecoration nameTextField = InputDecoration(
    icon: const Icon(Icons.account_circle_rounded),
    label: Text(
      'Full Name',
      style: AppStyle.defaultText,
    ),
  );

  static InputDecoration emailTextField = InputDecoration(
      icon: const Icon(Icons.email_rounded),
      label: Text(
        'Email',
        style: AppStyle.defaultText,
      ));

  static InputDecoration passwordTextField = InputDecoration(
    icon: const Icon(Icons.key_rounded),
    label: Text(
      'Password',
      style: AppStyle.defaultText,
    ),
  );

  static InputDecoration confirmPasswordTextField = InputDecoration(
    icon: const Icon(Icons.key_rounded),
    label: Text(
      'Confirm Password',
      style: AppStyle.defaultText,
    ),
  );

  static InputDecoration teacherIdTextField = InputDecoration(
    icon: const Icon(Icons.school_rounded),
    label: Text(
      'Teacher ID',
      style: AppStyle.defaultText,
    ),
  );

  static InputDecoration schoolTextField = InputDecoration(
    icon: const Icon(Icons.school_rounded),
    label: Text(
      'What is the name of your school?',
      style: AppStyle.defaultText,
    ),
  );
}
