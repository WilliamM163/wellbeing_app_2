import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(this.widget, {super.key});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.containerColour,
        borderRadius: BorderRadius.circular(15),
      ),
      child: widget,
    );
  }
}
