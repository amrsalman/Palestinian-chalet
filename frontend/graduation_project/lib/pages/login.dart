import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'home.dart';

import 'signup.dart';
import 'mainpage.dart';

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
        onPressed: () {Navigator.pushNamed(context, '/');},
        child: Icon(Icons.home),
        backgroundColor: Colors.redAccent,


      ),
      appBar: AppBar(
        backgroundColor: BackColor,
        title: const Text('Users Login', style: TextStyle(fontSize: 30),),
        centerTitle: true,

        
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
              Text("تسجيل دخول",
                  style: TextStyle(
                      color: MainColor,
                      fontSize: 35,
                      fontFamily: 'RobotoMono')),
              const SizedBox(height: 30),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "الإيميل",
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
                  labelText: "كلمة المرور",
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
                      //if (_formKey.currentState?.validate() ?? false) {
                      // _boxLogin.put("loginStatus", true);
                      //_boxLogin.put("userName", _controllerUsername.text);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Mainpage();
                          },
                        ),
                      );
                      //}
                    },
                    child: const Text(
                      "الدخول",
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
                          "التسجيل",
                          style: TextStyle(fontSize: 15, color: MainColor),
                        ),
                      ),
                      const Text("ليس لديك حساب ؟"),
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
                                return const Signup();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "اضغط هنا ",
                          style: TextStyle(fontSize: 15, color: MainColor),
                        ),
                      ),
                      const Text(" نسيت كلمة المرور؟"),
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
