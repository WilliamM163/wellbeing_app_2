import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/student_account/account_info/student_account_info.dart';
import 'package:wellbeing_app_2/student_account/agenda/student_agenda_page.dart';
import 'package:wellbeing_app_2/student_account/drawer/student_drawer.dart';
import 'package:wellbeing_app_2/student_account/home/student_home_page.dart';
import 'package:wellbeing_app_2/student_account/journal/student_journal_page.dart';
import 'package:wellbeing_app_2/student_account/quick_links/student_quick_links_page.dart';
import 'package:wellbeing_app_2/push_notifications/push_notifications.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Widget>? _pages;

  final List<BottomNavigationBarItem> _bottomNavigationBar = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.link_rounded),
      label: 'Quick Links',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit_document),
      label: 'Journal',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.view_list_rounded),
      label: 'Agenda',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  _onAccountTapped() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentAccountInfoScreen(widget.userData),
        ),
      );

  @override
  void initState() {
    setupPushNotifications(widget.userData['Teacher Id']);

    _pages = [
      StudentHomePage(widget.userData),
      StudentQuickLinksPage(widget.userData),
      const StudentJournalPage(),
      const StudentAgendaPage(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColour,
      appBar: AppBar(
        centerTitle: true,
        leading: const DrawerButton(),
        title: Text(
          'Taupānga Oranga',
          style: AppStyle.appBarTitle,
        ),
        actions: [
          if (widget.userData['Avatar'] == null)
            IconButton(
              onPressed: _onAccountTapped,
              icon: const Icon(Icons.account_circle_rounded),
            ),
          if (widget.userData['Avatar'] != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: _onAccountTapped,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.userData['Avatar']),
                ),
              ),
            ),
        ],
        backgroundColor: AppStyle.appBarColour,
      ),
      drawer: const StudentDrawer(),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: _pages!,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppStyle.navigationBarColour,
        elevation: 0,
        items: _bottomNavigationBar,
        currentIndex: _selectedIndex,
        selectedItemColor: AppStyle.primaryColour,
        unselectedItemColor: AppStyle.secondaryColour,
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
