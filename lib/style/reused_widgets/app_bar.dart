import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

AppBar customAppBar(
  BuildContext context,
  String title, {
  Color? color,
  double? height,
  Widget? action,
}) {
  return AppBar(
    toolbarHeight: height ?? 80,
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: color ?? AppStyle.appBarColour,
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
        Expanded(child: Text(title, style: AppStyle.mainTitle)),
        action ?? Container(),
      ],
    ),
  );
}
