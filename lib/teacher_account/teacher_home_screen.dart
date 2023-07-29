import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/teacher_account/account_info/teacher_account_info.dart';
import 'package:wellbeing_app_2/teacher_account/survey/teacher_survey_screen.dart';
import 'package:wellbeing_app_2/teacher_account/drawer/teacher_drawer.dart';
import 'package:wellbeing_app_2/teacher_account/manage_students/manage_students_screen.dart';
import 'package:wellbeing_app_2/teacher_account/quick_links/teacher_quick_links_screen.dart';
import 'package:wellbeing_app_2/teacher_account/quotes/teacher_quotes_screen.dart';
import 'package:wellbeing_app_2/teacher_account/resources/teacher_resources_screen.dart';
import 'package:wellbeing_app_2/teacher_account/widgets/action_tiles.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen(this.userData, {super.key});
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    final List<Map> actionsList = [
      {
        'Icon': Icons.assignment_add,
        'Title': 'Create Survey',
        'Description':
            'Send survey\'s to your students. Students can fill out responses. You will be able to read their feedback.',
        'Colour': Colors.purple.shade800,
        'Screen': TeacherSurveyScreen(userData),
      },
      {
        'Icon': Icons.link_rounded,
        'Title': 'Quick Links',
        'Description':
            'Add links. Student\'s will be able to access these links, if and when needed.',
        'Colour': Colors.blue.shade800,
        'Screen': TeacherQuickLinksScreen(),
      },
      {
        'Icon': Icons.library_books,
        'Title': 'Resources',
        'Description':
            'Add useful resources, and lessons for students to read.',
        'Colour': Colors.green.shade800,
        'Screen': const TeacherResourcesScreen(),
      },
      {
        'Icon': Icons.format_quote_rounded,
        'Title': 'Quotes',
        'Description': 'Add quotes. A student will see a new quote everyday.',
        'Colour': Colors.red.shade800,
        'Screen': TeacherQuotesScreen(),
      },
      {
        'Icon': Icons.school_rounded,
        'Title': 'Manage Students',
        'Description':
            'Link student\'s to your account, contact them, and check student\'s survey activity.',
        'Colour': Colors.orange.shade800,
        'Screen': ManageStudentsScreen(userData),
      },
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const DrawerButton(),
        title: Text(
          'Taupānga Oranga',
          style: AppStyle.appBarTitle,
        ),
        actions: [
          if (userData['Avatar'] == null)
            IconButton(
              onPressed: () => _onAccountTapped(context),
              icon: const Icon(Icons.account_circle_rounded),
            ),
          if (userData['Avatar'] != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => _onAccountTapped(context),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userData['Avatar']),
                ),
              ),
            ),
        ],
        backgroundColor: AppStyle.appBarColour,
      ),
      backgroundColor: AppStyle.backgroundColour,
      drawer: TeacherDrawer(userData, actionsList),
      body: Padding(
        padding: AppStyle.appPadding,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: actionsList.length,
            itemBuilder: (context, index) {
              return ActionTile(
                icon: actionsList[index]['Icon'],
                title: actionsList[index]['Title'],
                description: actionsList[index]['Description'],
                colour: actionsList[index]['Colour'],
                screen: actionsList[index]['Screen'],
              );
            }),
      ),
    );
  }

  void _onAccountTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherAccountInfoScreen(userData),
      ),
    );
  }
}
