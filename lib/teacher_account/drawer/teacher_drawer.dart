import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';
import 'package:wellbeing_app_2/teacher_account/account_info/teacher_account_info.dart';

class TeacherDrawer extends StatefulWidget {
  const TeacherDrawer(this.userData, this.navigationList, {super.key});
  final Map<String, dynamic> userData;
  final List navigationList;

  @override
  State<TeacherDrawer> createState() => _TeacherDrawerState();
}

class _TeacherDrawerState extends State<TeacherDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyle.containerColour,
      surfaceTintColor: AppStyle.containerColour,
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
            _navigationTiles(),
            _logout()
          ],
        ),
      ),
    );
  }

  Expanded _navigationTiles() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.navigationList.length,
        itemBuilder: (context, index) {
          return _navigationTile(index);
        },
      ),
    );
  }

  TextButton _logout() {
    return TextButton.icon(
      onPressed: () {
        FirebaseAuth.instance.signOut();
      },
      icon: const Icon(Icons.logout_rounded),
      label: Text(
        'Logout',
        style: AppStyle.defaultText,
      ),
    );
  }

  Widget _navigationTile(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => widget.navigationList[index]['Screen'],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                widget.navigationList[index]['Icon'],
                color: widget.navigationList[index]['Colour'],
              ),
              title: Text(
                widget.navigationList[index]['Title'],
                style: AppStyle.defaultText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.navigate_next_rounded),
              visualDensity: const VisualDensity(vertical: -4),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _accountDetails() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TeacherAccountInfoScreen(widget.userData)),
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
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Sorry this feature is not available yet',
                      style: AppStyle.defaultText,
                    ),
                  ));
                },
                icon: const Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}
