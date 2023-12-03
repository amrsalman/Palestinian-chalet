import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'home.dart';

import 'signup.dart';
import 'mainpage.dart';

class Admin extends StatefulWidget {
  const Admin({
    Key? key,
  }) : super(key: key);

  @override
  State<Admin> createState() => _LoginState();
}

class _LoginState extends State<Admin> {
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
    Color? MainColor =  Colors.white10;

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
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        //decoration: BoxDecoration(
        //  image: DecorationImage(
              //image: AssetImage("assets/images/img3.jpg"),
            //fit: BoxFit.cover
          //  )
      //  ),

        // key: _formKey,
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/images/image.jpeg"),
        //         fit: BoxFit.cover),
        //   ),
        child: SingleChildScrollView(
          
          padding: const EdgeInsets.all(30.0),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.center ,
            children: [
              const SizedBox(height: 80),
              /*Image.asset(
                'assets/images/1.png', // Add the path to your logo
                width: 200, // Set the desired width
                height: 200, // Set the desired height
              ),*/
              const SizedBox(height: 10),
               Text(
                "تسجيل دخول",
                style: TextStyle(color: BackColor, fontSize: 50, fontFamily: 'RobotoMono')
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 60),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BackColor,
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
                              return  Mainpage();
                            },
                          ),
                        );
                       //}
                    },
                    child: const Text(
                      "الدخول",
                    style: TextStyle( fontSize: 30, color: Colors.white),),
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