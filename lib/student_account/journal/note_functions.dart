import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/student_account/journal/note_editor.dart';
import 'package:wellbeing_app_2/student_account/journal/note_reader.dart';
import 'package:wellbeing_app_2/userId.dart';

openNote(BuildContext context, QueryDocumentSnapshot note) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return NoteReaderScreen(note.id);
  }));
}

deleteNote(BuildContext context, QueryDocumentSnapshot note) {
  FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection('notes')
      .doc(note.id)
      .delete();
  Navigator.of(context).pop();
}

editNote(BuildContext context, DocumentSnapshot note) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return NoteEditorScreen(note: note);
  }));
}
