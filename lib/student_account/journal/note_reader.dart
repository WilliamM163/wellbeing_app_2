import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellbeing_app_2/student_account/journal/note_functions.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/userId.dart';

class NoteReaderScreen extends StatelessWidget {
  const NoteReaderScreen(this.id, {super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notes')
          .doc(id)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        // checking the connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          int colorId = snapshot.data!['color_id'];

          return Scaffold(
            backgroundColor: AppStyle.cardsColor[colorId],
            appBar: customAppBar(
              context,
              '',
              color: AppStyle.cardsColor[colorId],
              height: 60,
              action: IconButton(
                  onPressed: () => editNote(context, snapshot.data!),
                  icon: const Icon(Icons.edit_rounded)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(snapshot.data!["note_title"], style: AppStyle.mainTitle),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.data!["creation_date"],
                    style: AppStyle.defaultText,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    snapshot.data!["note_content"],
                    style: AppStyle.defaultText,
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(
              "Error, the note was unable to load",
              style: GoogleFonts.nunito(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
