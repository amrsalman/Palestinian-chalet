import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation_project/model/user.dart';
import 'package:graduation_project/utils/User_preferneces.dart';
import 'package:graduation_project/widgets/AppBar_widget.dart';
import 'package:graduation_project/widgets/Button_widget.dart';
import 'package:graduation_project/widgets/Profile_widget.dart';
import 'package:graduation_project/widgets/TextField_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late USER user;
  @override
  void initState() {
    super.initState();

    user = UserPreferences.getUser();
  }

  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(),
          
        ),
title: Text('Edit Profile ', style: TextStyle(color: Colors.redAccent),),
centerTitle: true,
    ),
     body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                // ProfileWidget(
                //   imagePath: user.imagepath,
                //   isEdit: true,
                  
                //   onClicked: () async {
                //      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        
              

                //     if (image == null) return;
                //     final directory = await getApplicationDocumentsDirectory();
                //     final name = basename(image.path);
                //      final imageFile = File('${directory.path}/$name');
                //        final newImage =
                //         await File(image.path).copy(imageFile.path);

                //     setState(() => user = user.copy(imagePath: newImage.path));
                //   },
                // ),
                 const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Full Name',
                  text: user.name,
                   onChanged: (name) => user = user.copy(name: name),
                ),
                 const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Email',
                  text: user.email,
                   onChanged: (email) => user = user.copy(email: email),
                ),
                const SizedBox(height: 24),
                // Date of Birth TextField
                TextFieldWidget(
  label: 'Date of Birth',
  text: user.dateOfBirth ?? '', // Provide a default empty string if null
  onChanged: (dob) => user = user.copy(dateOfBirth: dob),
),
const SizedBox(height: 24),
// Mobile Number TextField
TextFieldWidget(
  label: 'Mobile Number',
  text: user.mobileNumber ?? '', // Provide a default empty string if null
  onChanged: (mobile) => user = user.copy(mobileNumber: mobile),
),
                const SizedBox(height: 24),
                // TextFieldWidget(
                //   label: 'About',
                //   text: user.about,
                //   maxLines: 5,
                //     onChanged: (about) => user = user.copy(about: about),
                // ),
                const SizedBox(height: 24),
                ButtonWidget(
                  text: 'Save',
                  onClicked: () {
                      UserPreferences.setUser(user);
                       Navigator.of(context).pop();
                  },
                ),
              ]
     ),
  );
}
