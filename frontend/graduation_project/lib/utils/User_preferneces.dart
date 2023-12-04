import 'dart:convert';

import 'package:graduation_project/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefrences;
  static const _keyUser = 'user';
  static const myUser = USER(
    imagepath: 'assets/images/real-madrid.jpg',
    name: 'Amer ammar Zagha',
    email: 'amerzagha@gmail.com',
    about:
        'Certified Personal Trainer and Nutritionist with years of experience in creating effective diets and training plans focused on achieving individual customers goals in a smooth way.',
    isDarckMode: false,
  );
  static Future init() async =>
      _prefrences = await SharedPreferences.getInstance();
  static Future setUser(USER user) async {
    final json = jsonEncode(user.toJson());
      await _prefrences.setString(_keyUser, json);
  }
  static USER getUser() {
    final json = _prefrences.getString(_keyUser);

    return json == null ? myUser : USER.fromJson(jsonDecode(json));
  }
}
