// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/link_tile.dart';
import 'package:wellbeing_app_2/userId.dart';

class TeacherQuickLinksScreen extends StatelessWidget {
  TeacherQuickLinksScreen({super.key});
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = customAppBar(context, 'Quick Links');
    final FloatingActionButton floatingActionButton =
        FloatingActionButton.extended(
      foregroundColor: Colors.white,
      backgroundColor: Colors.grey.shade900,
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
    String? description;
    String? link;
    String? emoji;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              surfaceTintColor: AppStyle.containerColour,
              title: Text(
                'Add Link',
                style: AppStyle.defaultText,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(
                        'Title',
                        style: AppStyle.defaultText,
                      ),
                    ),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(
                        'Description',
                        style: AppStyle.defaultText,
                      ),
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(
                        'Link',
                        style: AppStyle.defaultText,
                      ),
                    ),
                    onChanged: (value) {
                      link = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(
                        'Emoji',
                        style: AppStyle.defaultText,
                      ),
                    ),
                    onChanged: (value) {
                      emoji = value;
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    if (isSending) const CircularProgressIndicator(),
                    TextButton.icon(
                      onPressed: isSending == false
                          ? () async {
                              setState(() {
                                isSending = !isSending;
                              });
                              bool isValid = await confirmDetails(
                                title: title,
                                description: description,
                                link: link,
                                emoji: emoji,
                              );
                              if (isValid) {
                                await submitLink(
                                  context: context,
                                  link: link!,
                                  title: title!,
                                  description: description!,
                                  emoji: emoji!,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please make sure all fields have been entered',
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                isSending = !isSending;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.check),
                      label: Text(
                        'Sumbit',
                        style: AppStyle.defaultText,
                      ),
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

  void deleteLink(String linkId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('quick links')
        .doc(linkId)
        .delete();
  }

  Future<bool> confirmDetails({
    required String? title,
    required String? description,
    required String? link,
    required String? emoji,
  }) async {
    if (title == null) {
      return false;
    }
    if (description == null) {
      return false;
    }
    if (link == null) {
      final bool isValidURL = await canLaunchUrl(Uri.parse(link!));
      if (!isValidURL) {
        return false;
      }
    }
    if (emoji == null) {
      return false;
    }
    return true;
  }

  submitLink({
    required BuildContext context,
    required String link,
    required String title,
    required String description,
    required String emoji,
  }) async {
    final Timestamp date = Timestamp.now();
    var linkCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('quick links');
    linkCollection.add({
      'Title': title,
      'Description': description,
      'Link': link,
      'Emoji': emoji,
      'Date': date,
    });

    Navigator.of(context).pop();
  }
}
