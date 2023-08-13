import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellbeing_app_2/screens/error_screen.dart';
import 'package:wellbeing_app_2/screens/loading_screen.dart';
import 'package:wellbeing_app_2/student_account/agenda/agenda_consts.dart';
import 'package:wellbeing_app_2/student_account/agenda/edit_task.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/userId.dart';

class StudentAgendaPage extends StatefulWidget {
  const StudentAgendaPage({super.key});

  @override
  State<StudentAgendaPage> createState() => _StudentAgendaPageState();
}

class _StudentAgendaPageState extends State<StudentAgendaPage> {
  bool showDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColour,
      body: Padding(
        padding: AppStyle.appPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleAndSelector(),
            const Divider(),
            if (showDone == false) _doing(),
            if (showDone == true) _done(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _addTask(context),
    );
  }

  Expanded _done() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('agenda')
            .orderBy('Completion Date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            final List tasks = snapshot.data!.docs;
            if (tasks.isEmpty) {
              return _noCompletedTasks();
            }
            return _tasks(tasks);
          }
          return const ErrorScreen();
        },
      ),
    );
  }

  Center _noCompletedTasks() {
    return Center(
      child: Text(
        'No completed tasks, please complete a task',
        style: AppStyle.defaultText,
      ),
    );
  }

  Row _titleAndSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Your Agenda List', style: AppStyle.mainTitle),
        _dropDownMenu(),
      ],
    );
  }

  DropdownButton<bool> _dropDownMenu() {
    return DropdownButton(
      value: showDone,
      items: [
        DropdownMenuItem(
          value: false,
          child: Text(
            'Doing',
            style: AppStyle.defaultText,
          ),
        ),
        DropdownMenuItem(
          value: true,
          child: Text(
            'Done',
            style: AppStyle.defaultText,
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          showDone = value!;
        });
      },
    );
  }

  Widget _doing() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('agenda')
            .orderBy('Priority', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            List tasks = snapshot.data!.docs;
            if (tasks.isEmpty) {
              return _noTasks();
            }

            // Take out completed tasks
            List uncompletedTasks = [];
            for (int index = 0; index < tasks.length; index++) {
              try {
                tasks[index]['Completion Date'];
              } catch (e) {
                uncompletedTasks.add(tasks[index]);
              }
            }

            tasks = uncompletedTasks;

            // Sort tasks by Priority and Finish Date
            tasks.sort((a, b) {
              final priorityA = a['Priority'];
              final priorityB = b['Priority'];
              if (priorityA == priorityB) {
                final finishDateA = a['Finish Date'];
                final finishDateB = b['Finish Date'];
                return finishDateA.compareTo(finishDateB);
              }
              return priorityA.compareTo(priorityB);
            });

            return _tasks(tasks);
          }
          return const ErrorScreen();
        },
      ),
    );
  }

  ListView _tasks(List<dynamic> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final String id = tasks[index].id;
        final String task = tasks[index]['Task'];
        final Color priorityColour =
            prioritys[tasks[index]['Priority']]['Colour'];
        final String priority = prioritys[tasks[index]['Priority']]['Priority'];
        final String finishDate =
            DateFormat(dateFormat).format(tasks[index]['Finish Date'].toDate());
        final String description = tasks[index]['Description'];
        final bool isCompleted =
            tasks[index].data().containsKey('Completion Date');

        return Column(
          children: [
            _task(id, task, priorityColour, priority, finishDate, description,
                isCompleted),
            const SizedBox(height: 10),
            if (index == tasks.length - 1) const SizedBox(height: 50),
          ],
        );
      },
    );
  }

  Widget _task(String id, String task, Color priorityColour, String priority,
      String finishDate, String description, bool isCompleted) {
    return GestureDetector(
      onTap: () {
        _taskActions(id, isCompleted);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task,
                            style: AppStyle.tileTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: priorityColour.withOpacity(0.3),
                          ),
                          child: Text(
                            priority,
                            style: AppStyle.defaultText,
                          ),
                        )
                      ],
                    ),
                    Text(
                      finishDate,
                      style: AppStyle.defaultText,
                    ),
                    const Divider(),
                    Text(
                      'Description:',
                      style: AppStyle.defaultText.copyWith(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Text(description, style: AppStyle.defaultText),
                  ],
                ),
              ),
              Container(height: 15, color: priorityColour.withOpacity(0.7)),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _taskActions(String id, bool isCompleted) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCompleted == false)
                  TextButton.icon(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('agenda')
                          .doc(id)
                          .update({
                        'Completion Date': Timestamp.now(),
                      });
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.done_rounded),
                    label: const Text('Finish Task'),
                  ),
                if (isCompleted == false)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'Sorry this feature is not available yet',
                        style: AppStyle.defaultText,
                      )));
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Edit Task'),
                  ),
                TextButton.icon(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('agenda')
                        .doc(id)
                        .delete();
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_rounded),
                  label: const Text('Delete Task'),
                ),
              ],
            ),
          );
        });
  }

  Center _noTasks() {
    return Center(
      child: Text(
        'No tasks, please add a task',
        style: AppStyle.defaultText,
      ),
    );
  }

  FloatingActionButton _addTask(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditTask(isEditing: false),
          ),
        );
      },
      label: Text(
        'Add a task',
        style: AppStyle.defaultText,
      ),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
    );
  }
}
