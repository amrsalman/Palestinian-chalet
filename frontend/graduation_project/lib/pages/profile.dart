import 'package:flutter/material.dart';
import 'package:graduation_project/model/user.dart';
import 'package:graduation_project/pages/edit_profilePage.dart';
import 'package:graduation_project/utils/User_preferneces.dart';
import 'package:graduation_project/widgets/AppBar_widget.dart';
import 'package:graduation_project/widgets/Button_widget.dart';
import 'package:graduation_project/widgets/Number_widget.dart';
import 'package:graduation_project/widgets/Profile_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();

    return Scaffold(
        appBar: buildAppBar(context),
        backgroundColor: Colors.white,
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: user.imagepath,
              onClicked: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
                setState(() {});
              },
            ),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 24),
            Center(child: BuildUpgradeButton()),
            const SizedBox(height: 20),
            NumbersWidget(),
            const SizedBox(height: 40),
            buildAbout(user),
          ],
        ));
  }

  Widget buildName(USER user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Date of Birth: ${user.dateOfBirth}', // Display Date of Birth
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            'Mobile Number: ${user.mobileNumber}', // Display Mobile Number
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  Widget BuildUpgradeButton() => ButtonWidget(
        text: 'Upgrade to Pro',
        onClicked: () {},
      );

  Widget buildAbout(USER user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: TextStyle(fontSize: 25, height: 1, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
