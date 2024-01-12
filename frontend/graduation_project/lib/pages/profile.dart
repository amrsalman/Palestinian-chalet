import 'package:flutter/material.dart';
import 'package:graduation_project/model/user.dart';
import 'package:graduation_project/pages/edit_profilePage.dart';
import 'package:graduation_project/utils/User_preferneces.dart';
import 'package:graduation_project/widgets/AppBar_widget.dart';
import 'package:graduation_project/widgets/Button_widget.dart';
import 'package:graduation_project/widgets/Profile_widget.dart';
import 'package:graduation_project/widgets/Number_widget.dart';

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
        
      
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
           SizedBox(
            height: 135, // Adjust the size to fit your design
            child: Center(
              child: CircleAvatar(
                radius: 64, // The radius of the circle
                backgroundColor: Colors.redAccent, // The background color of the circle
                child: Icon(
                  Icons.person,
                  size: 70, // The size of the icon inside the circle
                  color: Colors.white, // The color of the icon
                ),
              ),
            ),
          ),
          // ProfileWidget(
          //   imagePath: user.imagepath, // Make sure this points to the right variable
          //   onClicked: () async {
          //     await Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => EditProfilePage()),
          //     );
          //     setState(() {});
          //   },
          // ),
          const SizedBox(height: 24),
             NumbersWidget(),
          const SizedBox(height: 24),
          buildUserInfo('Name', user.name, Icons.person),
          const SizedBox(height: 24),
        buildUserInfo('Birthday', user.dateOfBirth.toString(), Icons.cake),
        const SizedBox(height: 24),
buildUserInfo('Phone', user.mobileNumber.toString(), Icons.phone),
const SizedBox(height: 24),

         // Replace with actual data
          buildUserInfo('Email', user.email, Icons.email),
          
          SizedBox(height: 30),
        
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ElevatedButton(
              child: Text('Edit Profile'),
              onPressed: ()  async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              setState(() {});
            },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent, // Background color
                onPrimary: Colors.white, // Text color
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserInfo(String title, String data, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent), // Icon with color
          SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
