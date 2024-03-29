import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'home.dart';
import 'package:http/http.dart' as http;
import 'signup.dart';
import 'mainpage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation_project/pages/Forget_Password.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:web_socket_channel/io.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  Future<void> _login() async {
    final String url = 'http://10.0.2.2:8080/api/v1/user/login/client';

    final Map<String, String> body = {
      'username': _controllerUsername.text,
      'password': _controllerPassword.text,
    };

    try {
      final response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 200) {
        // Successful login
        final data = json.decode(response.body);
        await _saveUserData(data['token'], data['user']['username']);
        print('Logged in: ${data['user']['username']}');
        // Initialize WebSocket channel after successful login
        final IOWebSocketChannel channel =
            IOWebSocketChannel.connect('ws://10.0.2.2:8081?user=${data['user']['username']}');
        channel.stream.listen((message) {
          print("////////////////////////////////////////////////");
          print(message);
          // Handle WebSocket message
          showNotification(message);
        });
        // Navigate to the next screen or perform necessary actions
         // تحديث اسم المستخدم في مزود حالة المستخدم
        //Provider.of<UserProvider>(context, listen: false).setUsername(data['user']['username']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Mainpage();
            },
          ),
        );
      } else if (response.statusCode == 404) {
        // User not found or invalid credentials
        print('User not found or invalid credentials.');
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password.'),
          ),
        );
      } else {
        // Handle other HTTP errors
        print('Login failed: ${response.statusCode}');
        // Show a generic error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      print('Exception during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during login: $e'),
        ),
      );
    }
  }
  Future<void> showNotification(String message) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'Basic Channel',
      title: 'New',
      body: message,
    ),
  );
}


  Future<void> _saveUserData(String token, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('username', username);
  }

  bool _obscurePassword = true;
  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");

  @override
  Widget build(BuildContext context) {
    /*if (_boxLogin.get("loginStatus") ?? false) {
      return home();
    }*/

    Color? BackColor = Colors.redAccent;
    Color? MainColor = Colors.redAccent;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
        child: Icon(Icons.home),
        backgroundColor: Colors.redAccent,
      ),
      appBar: AppBar(
      backgroundColor: Colors.transparent,
        elevation: 0,
      //  title: const Text('Users Login', style: TextStyle(fontSize: 30,color: Colors.redAccent),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(),
        )


      ),
      body: Container(
        width: double.infinity,
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/img3.jpg"),
            fit: BoxFit.cover,
            ),
        ),*/
        // key: _formKey,
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/images/image.jpeg"),
        //         fit: BoxFit.cover),
        //   ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              //  Image.asset(
              //  'assets/images/5.png', // Add the path to your logo
              //  width: 300, // Set the desired width
              //  height: 200, // Set the desired height
              //),
              //const SizedBox(height: 10),
              Text("Login",
                  style: TextStyle(
                      color: MainColor,
                      fontSize: 35,
                      fontFamily: 'RobotoMono')),
              const SizedBox(height: 30),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "User Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال الإيميل";
                  } else if (!_boxAccounts.containsKey(value)) {
                    return "لا يوجد حساب بهذا الإيميل !";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال كلمة المرور";
                  } else if (value !=
                      _boxAccounts.get(_controllerUsername.text)) {
                    return "كلمة المرور خاطئة !";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      /*if (_formKey.currentState?.validate() ?? false) {
                        // _boxLogin.put("loginStatus", true);
                        //_boxLogin.put("userName", _controllerUsername.text);
                        
                      }*/
                      _login();
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Signup();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 15, color: MainColor),
                        ),
                      ),
                      const Text("<--You don't have an account"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return  ForgotPasswordPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Press here ",
                          style: TextStyle(fontSize: 15, color: MainColor),
                        ),
                      ),
                      const Text("<--Forgot Password"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
