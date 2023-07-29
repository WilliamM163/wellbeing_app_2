import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/student_account/account_info/student_account_info.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class StudentDrawer extends StatefulWidget {
  const StudentDrawer(this.userData, {super.key, required this.onTap});
  final Map<String, dynamic> userData;
  final Function(int index) onTap;

  @override
  State<StudentDrawer> createState() => _StudentDrawerState();
}

class _StudentDrawerState extends State<StudentDrawer> {
  List navigatonList = [
    {'Page': 'Home', 'Icon': Icons.home},
    {'Page': 'Quick Links', 'Icon': Icons.link_rounded},
    {'Page': 'Journal', 'Icon': Icons.edit_document},
    {'Page': 'Agenda', 'Icon': Icons.view_list_rounded},
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyle.drawerColour,
      surfaceTintColor: AppStyle.drawerColour,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Taupānga Oranga',
            style: AppStyle.appBarTitle,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            _accountDetails(),
            const Divider(),
            _navigationTiles()
          ],
        ),
      ),
    );
  }

  Expanded _navigationTiles() {
    return Expanded(
      child: ListView.builder(
        itemCount: navigatonList.length,
        itemBuilder: (context, index) => Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.onTap(index);
              },
              child: ListTile(
                leading: Icon(navigatonList[index]['Icon']),
                title: Text(
                  navigatonList[index]['Page'],
                  style: AppStyle.defaultText
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.navigate_next_rounded),
                visualDensity: const VisualDensity(vertical: -4),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _accountDetails() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentAccountInfoScreen(widget.userData)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (widget.userData['Avatar'] == null)
              const Icon(Icons.account_circle_rounded, size: 60),
            if (widget.userData['Avatar'] != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.userData['Avatar']),
                  radius: 30,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      widget.userData['Name'],
                      style: AppStyle.defaultText
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  FittedBox(
                    child: Text(
                      widget.userData['Email'],
                      style: AppStyle.defaultText,
                    ),
                  )
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}
