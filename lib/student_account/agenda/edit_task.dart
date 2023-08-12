import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/style/reused_widgets/app_bar.dart';
import 'package:wellbeing_app_2/userId.dart';
import 'package:wellbeing_app_2/student_account/agenda/agenda_consts.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key, required this.isEditing});
  final bool isEditing;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int priority = 2;
  DateTime? finishDate;

  bool isSendingData = false;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    // add stuff here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        widget.isEditing ? "Edit Task" : "Add Task",
      ),
      backgroundColor: AppStyle.backgroundColour,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _task(),
              const SizedBox(height: 10),
              _buttons(),
              const SizedBox(height: 10),
              _description(),
              _space(),
              _submitTask(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _description() {
    return TextFormField(
      controller: _descriptionController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your task';
        }
        return null;
      },
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Description',
      ),
      style: AppStyle.defaultText,
    );
  }

  Widget _buttons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _priority(),
          const SizedBox(width: 20),
          _finishDate(),
        ],
      ),
    );
  }

  OutlinedButton _finishDate() {
    DateTime? _finishDate;
    return OutlinedButton.icon(
      onPressed: () async {
        _finishDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (_finishDate != null) {
          setState(() {
            finishDate = _finishDate;
          });
        }
      },
      icon: const Icon(Icons.timer_rounded),
      label: Text(
        finishDate == null
            ? 'Finish Date'
            : DateFormat(dateFormat).format(finishDate!),
        style: AppStyle.defaultText,
      ),
    );
  }

  OutlinedButton _priority() {
    return OutlinedButton.icon(
      onPressed: () {
        _prioritySelector(prioritys);
      },
      icon: const Icon(Icons.category_rounded),
      label: Text(
        prioritys[priority]['Priority'],
        style: AppStyle.defaultText,
      ),
    );
  }

  Future<dynamic> _prioritySelector(List<Map<dynamic, dynamic>> prioritys) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: prioritys.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      setState(() {
                        priority = index;
                      });
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: prioritys[index]['Colour'],
                      ),
                      title: Text(
                        prioritys[index]['Priority'],
                        style: AppStyle.defaultText,
                      ),
                    ),
                  ),
                  if (index < prioritys.length - 1) const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  TextFormField _task() {
    return TextFormField(
      controller: _taskController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your task';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Task',
      ),
      style: AppStyle.mainTitle,
    );
  }

  SizedBox _submitTask() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final bool isDataValid = _formKey.currentState!.validate();
          if (isDataValid) {
            setState(() {
              isSendingData = !isSendingData;
            });
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('agenda')
                .doc()
                .set({
              'Task': _taskController.text,
              'Description': _descriptionController.text,
              'Priority': priority,
              if (finishDate == null) 'Finish Date': Timestamp.now(),
              if (finishDate != null)
                'Finish Date': Timestamp.fromDate(finishDate!),
            });
            Navigator.pop(context);
          }
        },
        icon: isSendingData
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.done),
        label: Text('Submit Task', style: AppStyle.defaultText),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[800],
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Expanded _space() => Expanded(child: Container());
}
