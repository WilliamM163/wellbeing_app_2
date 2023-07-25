import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colornames/colornames.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/userId.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note});

  final DocumentSnapshot? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int colorId = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateFormat('dd/MM/yyy hh:mm a').format(DateTime.now());
  Timestamp dateTimestamp = Timestamp.now();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainController = TextEditingController();

  bool _hasBuiltWidget = false;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    if (widget.note != null) {
      colorId = widget.note!['color_id'];
      date = widget.note!['creation_date'];
      dateTimestamp = widget.note!['creation_date_timestamp'];
      _titleController.text = widget.note!['note_title'];
      _mainController.text = widget.note!['note_content'];
      _isEditing = true;
    }
    _hasBuiltWidget = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasBuiltWidget) {
      return Container();
    }

    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorId],
      appBar: customAppBar(
        context,
        _isEditing ? "Editing my note" : "Add a new note",
        color: AppStyle.cardsColor[colorId],
        height: 60,
        action: IconButton(
          onPressed: () {
            moreColours(context);
          },
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
              ),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(height: 8),
            Text(date, style: AppStyle.defaultText),
            const SizedBox(height: 28),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note content',
              ),
              style: AppStyle.defaultText,
            ),
          ],
        ),
      ),
      floatingActionButton: myFloatingActionButton(),
    );
  }

  Widget myFloatingActionButton() {
    if (!_isSaving) {
      return FloatingActionButton(
        onPressed: () async {
          setState(() {
            _isSaving = !_isSaving;
          });
          if (widget.note != null) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .collection('notes')
                .doc(widget.note!.id)
                .update({
              "note_title": _titleController.text,
              "creation_date": date,
              "creation_date_timestamp": dateTimestamp,
              "note_content": _mainController.text,
              "color_id": colorId
            }).then((value) {
              Navigator.of(context).pop();
            }).catchError((error) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$error')));
            });
            return;
          }

          FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection('notes')
              .add({
            "note_title": _titleController.text,
            "creation_date": date,
            "creation_date_timestamp": dateTimestamp,
            "note_content": _mainController.text,
            "color_id": colorId
          }).then((value) {
            Navigator.of(context).pop();
          }).catchError((error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$error')));
          });
        },
        child: const Icon(Icons.save),
      );
    }

    return const FloatingActionButton(
        onPressed: null, child: CircularProgressIndicator());
  }

  Future<dynamic> moreColours(context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: AppStyle.cardsColor.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading:
                    CircleAvatar(backgroundColor: AppStyle.cardsColor[index]),
                title: Text(ColorNames.guess(AppStyle.cardsColor[index])),
                onTap: () {
                  setState(() {
                    colorId = index;
                  });
                  Navigator.of(context).pop();
                },
              );
            });
      },
    );
  }
}
