// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/userId.dart';

class TeacherQuickLinksScreen extends StatelessWidget {
  TeacherQuickLinksScreen({super.key});
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = customAppBar(context, 'Quick Links');
    final FloatingActionButton floatingActionButton =
        FloatingActionButton.extended(
      onPressed: () {
        addLink(context);
      },
      label: Text(
        'Add a link',
        style: AppStyle.defaultText,
      ),
      icon: const Icon(Icons.add),
    );
    const FloatingActionButtonLocation fabLocation =
        FloatingActionButtonLocation.centerFloat;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('quick links')
          .orderBy('Date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: appBar,
            body: Center(
              child: Text(
                'Loading ...',
                style: AppStyle.defaultText,
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          List links = snapshot.data!.docs;

          if (links.isEmpty) {
            return Scaffold(
              appBar: appBar,
              backgroundColor: AppStyle.backgroundColour,
              body: Padding(
                padding: AppStyle.appPadding,
                child: Center(
                  child: Text(
                    'No links, please add a link',
                    style: AppStyle.defaultText,
                  ),
                ),
              ),
              floatingActionButton: floatingActionButton,
              floatingActionButtonLocation: fabLocation,
            );
          } else {
            return Scaffold(
              appBar: appBar,
              backgroundColor: AppStyle.backgroundColour,
              body: Padding(
                  padding: AppStyle.appPadding,
                  child: ListView.builder(
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            LinkTile(
                              links: links,
                              index: index,
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      })),
              floatingActionButton: floatingActionButton,
              floatingActionButtonLocation: fabLocation,
            );
          }
        }

        return Scaffold(
          appBar: appBar,
          body: const ErrorScreen(),
        );
      },
    );
  }

  Future<void> addLink(BuildContext context) {
    String? title;
    String? link;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Link'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Link'),
                    ),
                    onChanged: (value) {
                      link = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Title'),
                    ),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    if (isSending) const CircularProgressIndicator(),
                    if (isSending) const SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: isSending == false
                          ? () async {
                              setState(() {
                                isSending = !isSending;
                              });
                              if (link != null) {
                                await submitLink(context, link!, title);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please add a link'),
                                  ),
                                );
                              }
                              setState(() {
                                isSending = !isSending;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.check),
                      label: const Text('Sumbit'),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  submitLink(BuildContext context, String link, String? title) async {
    final Timestamp date = Timestamp.now();
    var linkCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('links');
    linkCollection.add({
      'Link': link,
      'Title': title,
      'Date': date,
    });

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

class LinkTile extends StatelessWidget {
  const LinkTile({
    super.key,
    required this.links,
    required this.index,
  });

  final List links;
  final int index;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: AppStyle.backgroundColour,
            context: context,
            builder: (context) => Center(
              child: TextButton.icon(
                onPressed: () {
                  deleteLink(links[index].id);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_rounded),
                label: Text(
                  'Delete Link',
                  style: AppStyle.defaultText,
                ),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Text(links[index]),
        ),
      ),
    );
  }

  void deleteLink(String linkId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('links')
        .doc(linkId)
        .delete();
  }
}
