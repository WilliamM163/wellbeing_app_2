import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';

class GraphInfoScreen extends StatelessWidget {
  const GraphInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Graph Info'),
      backgroundColor: AppStyle.backgroundColour,
      body: Padding(
        padding: AppStyle.appPadding,
        child: Text(
          'The info for your wellbeing graph comes from the first question of the wellbeing survey that your teacher sends out. The info about how many tasks you have done comes from your agenda page. All information about your tasks is not shared with anyone. Only the general graph and your survey response is sent to your teacher.',
          style: AppStyle.defaultText.copyWith(fontSize: 15),
        ),
      ),
    );
  }
}
