import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/link_tile.dart';

class StudentQuickLinksPage extends StatelessWidget {
  const StudentQuickLinksPage(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userData['Teacher Id'])
            .collection('quick links')
            .orderBy('Date')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final List<DocumentSnapshot> links = snapshot.data!.docs;
            if (links.isEmpty) {
              return Padding(
                padding: AppStyle.appPadding,
                child: Center(
                  child: Text(
                    'No links available',
                    style: AppStyle.defaultText,
                  ),
                ),
              );
            } else {
              return Padding(
                  padding: AppStyle.appPadding,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        return LinkTile(
                          links: links,
                          index: index,
                          onTap: () {
                            launchUrl(
                              Uri.parse(links[index]['Link']),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                        );
                      }));
            }
          }
          return const ErrorScreen();
        });
  }
}
