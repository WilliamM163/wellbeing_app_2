import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

AppBar customAppBar(BuildContext context, String title) {
  return AppBar(
    toolbarHeight: 80,
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: AppStyle.appBarColour,
    title: Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
        ),
        const SizedBox(width: 7),
        Text(title, style: AppStyle.mainTitle),
      ],
    ),
  );
}
