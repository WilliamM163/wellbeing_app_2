import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.colour,
    required this.screen,
  });
  final IconData icon;
  final String title;
  final String description;
  final Color colour;
  final StatelessWidget screen;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: colour,
                      size: 30,
                    ),
                    Text(
                      title,
                      style: AppStyle.tileTitle,
                    ),
                    Text(
                      description,
                      style: AppStyle.tileDescription,
                    ),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.keyboard_double_arrow_right_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
