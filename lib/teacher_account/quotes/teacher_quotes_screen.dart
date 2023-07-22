// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/style/reused_widgets/container.dart';
import 'package:wellbeing_app_2/userId.dart';

class TeacherQuotesScreen extends StatelessWidget {
  TeacherQuotesScreen({super.key});
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = customAppBar(context, 'Quotes');
    final FloatingActionButton floatingActionButton =
        FloatingActionButton.extended(
      onPressed: () {
        addQuote(context);
      },
      label: Text(
        'Add a quote',
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
          .collection('quotes')
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
          List quotes = snapshot.data!.docs;

          if (quotes.isEmpty) {
            return Scaffold(
              appBar: appBar,
              backgroundColor: AppStyle.backgroundColour,
              body: Padding(
                padding: AppStyle.appPadding,
                child: Center(
                  child: Text(
                    'No quotes, please add a quote',
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
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            QuoteTile(
                              quotes: quotes,
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

  Future<void> addQuote(BuildContext context) {
    String? quote;
    String? author;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Quote'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Quote'),
                    ),
                    onChanged: (value) {
                      quote = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Author'),
                    ),
                    onChanged: (value) {
                      author = value;
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
                              if (quote != null) {
                                await submitQuote(context, quote!, author);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please add a quote'),
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

  submitQuote(BuildContext context, String quote, String? author) async {
    final Timestamp date = Timestamp.now();
    var quoteCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('quotes');
    quoteCollection.add({
      'Quote': quote,
      'Author': author,
      'Date': date,
    });

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

class QuoteTile extends StatelessWidget {
  const QuoteTile({
    super.key,
    required this.quotes,
    required this.index,
  });

  final List quotes;
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
                  deleteQuote(quotes[index].id);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_rounded),
                label: Text(
                  'Delete Quote',
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
                '"${quotes[index]['Quote']}"',
                style: AppStyle.defaultText,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (quotes[index]['Author'] != null)
                    Text(
                      quotes[index]['Author'],
                      style: AppStyle.defaultText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  if (quotes[index]['Author'] == null)
                    Text(
                      'Unknown',
                      style: AppStyle.defaultText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteQuote(String quoteId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('quotes')
        .doc(quoteId)
        .delete();
  }
}
