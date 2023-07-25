import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/student_account/journal/note_functions.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

Widget noteCard(QueryDocumentSnapshot note) {
  return Builder(builder: (context) {
    return InkWell(
      onTap: () {
        openNote(context, note);
      },
      onLongPress: () {
        bottomSheet(context, note);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppStyle.cardsColor[note['color_id']],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note["note_title"],
              style: AppStyle.tileTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(note["creation_date"], style: AppStyle.defaultText),
            const SizedBox(height: 8),
            Text(
              note["note_content"],
              style: AppStyle.defaultText,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  });
}

Future bottomSheet(BuildContext context, QueryDocumentSnapshot note) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                openNote(context, note);
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Note'),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                editNote(context, note);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Note'),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                deleteNote(context, note);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete Note'),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Dismiss'),
            )
          ],
        ),
      );
    },
  );
}
