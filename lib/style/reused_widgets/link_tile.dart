import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';

class LinkTile extends StatelessWidget {
  const LinkTile({
    super.key,
    required this.links,
    required this.index,
    required this.onTap,
  });

  final List links;
  final int index;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                links[index]['Emoji'],
                style: const TextStyle(fontSize: 40),
              ),
              Text(
                links[index]['Title'],
                style: AppStyle.tileTitle,
              ),
              Text(
                links[index]['Description'],
                style: AppStyle.tileDescription,
                maxLines: 3,
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      links[index]['Link'],
                      style: AppStyle.tileLink,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.keyboard_double_arrow_right_rounded),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
