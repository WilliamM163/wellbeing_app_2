// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_selector/emoji_selector.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/userId.dart';

class TeacherQuickLinksScreen extends StatelessWidget {
  TeacherQuickLinksScreen({super.key});
  bool isSending = false;
  EmojiData? emojiData;

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
                      ),
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        return LinkTile(links: links, index: index);
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
                  TextButton.icon(
                      onPressed: () async {
                        await emojiPicker(context);
                      },
                      icon: const Icon(Icons.library_add_rounded),
                      label: Text('Add Icon', style: AppStyle.defaultText)),
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
                              bool isValid = confirmDetails(
                                title: title,
                                description: description,
                                link: link,
                                emojiData: emojiData,
                              );
                              if (isValid) {
                                await submitLink(
                                  context: context,
                                  link: link!,
                                  title: title!,
                                  description: description!,
                                  emojiData: emojiData!,
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

  emojiPicker(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          if (emojiData == null) {
            return EmojiSelector(
              padding: const EdgeInsets.all(20),
              onSelected: (emoji) {
                setState(() => emojiData = emoji);
              },
            );
          } else {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emojiData!.char, style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        emojiData = null;
                      });
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: Text(
                      'Change Icon',
                      style: AppStyle.defaultText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.done_rounded),
                    label: Text(
                      'Done',
                      style: AppStyle.defaultText,
                    ),
                  )
                ],
              ),
            );
          }
        });
      },
    );
  }

  bool confirmDetails({
    required String? title,
    required String? description,
    required String? link,
    required EmojiData? emojiData,
  }) {
    if (title == null) {
      return false;
    }
    if (description == null) {
      return false;
    }
    if (link == null) {
      return false;
    }
    if (emojiData == null) {
      return false;
    }
    return true;
  }

  submitLink({
    required BuildContext context,
    required String link,
    required String title,
    required String description,
    required EmojiData emojiData,
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
      'Emoji': emojiData.char,
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

  void deleteLink(String linkId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('quick links')
        .doc(linkId)
        .delete();
  }
}
