import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyle.containerColour,
      surfaceTintColor: AppStyle.containerColour,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Taupānga Oranga',
            style: AppStyle.appBarTitle,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            const Divider(),
            accountDetails(),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Padding accountDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (userData['Avatar'] == null)
            const Icon(Icons.account_circle_rounded, size: 60),
          if (userData['Avatar'] != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(userData['Avatar']),
                radius: 30,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    userData['Name'],
                    style: AppStyle.defaultText
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                // const SizedBox(height: 10),
                FittedBox(
                  child: Text(
                    userData['Email'],
                    style: AppStyle.defaultText,
                  ),
                )
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
        ],
      ),
    );
  }
}
