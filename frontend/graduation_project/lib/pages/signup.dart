import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeSecondName = FocusNode();
  final FocusNode _focusNodeBD = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeBankAcount = FocusNode();

  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final FocusNode _focusNodeMobile = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerSecondName = TextEditingController();
  final TextEditingController _controllerBD = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerMobile = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerBankAcount = TextEditingController();
  final TextEditingController _controllerConFirmPassword =
      TextEditingController();

  final Box _boxAccounts = Hive.box("accounts");
  Future<void> signUp() async {
    final response = await http
        .post(
          Uri.parse(
              'http://10.0.2.2:8080/api/v1/user'), // Replace with your server URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'username': _controllerUsername.text,
            'email': _controllerEmail.text,
            'password': _controllerPassword.text,
            'phone': _controllerMobile.text,
            'fname': _controllerFirstName.text,
            'lname': _controllerSecondName.text,
            'living': _controllerSecondName.text,
            'IBNA': _controllerBankAcount.text,
            'date_of_birth': _controllerBD.text,
            // Add other relevant fields here
          }),
        )
        .timeout(const Duration(
            seconds: 30)); // Adjust the timeout duration as needed

    if (response.statusCode == 200) {
      // Successful signup, handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 200,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text("Successfully Registered"),
        ),
      );
      print('Signup successful');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("We sent you an email, please verify your email address"),
        ),
      );
    } else {
      // Handle errors, show error messages, etc.
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String errorMessage = responseData['message'] ?? 'Signup failed';
      print('Signup failed: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              /*Image.asset(
                'assets/images/download.png', // Add the path to your logo
                width: 200, // Set the desired width
                height: 200, // Set the desired height
              ),*/
              const SizedBox(height: 10),
              Text("Sign Up",
                  style: TextStyle(color: MainColor, fontSize: 40)),
              const SizedBox(height: 15),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "UserName",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال إسم المسنخدم";
                  } else if (_boxAccounts.containsKey(value)) {
                    return "الإسم مستخدم بالفعل";
                  }

                  return null;
                },
                onEditingComplete: () => _focusNodeFirstName.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerFirstName,
                focusNode: _focusNodeFirstName,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "First Name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "please enter your firstname ";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodeSecondName.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerSecondName,
                focusNode: _focusNodeSecondName,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "SecondName",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter your SecondName";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodeBD.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerBD,
                focusNode: _focusNodeBD,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Date of Birth (dd/mm/yy)",
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "please enter your Date of birth ";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodeEmail.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerEmail,
                focusNode: _focusNodeEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال الإيميل";
                  } else if (!(value.contains('@') && value.contains('.'))) {
                    return "الإيميل غير صحيح";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodePassword.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerMobile,
                focusNode: _focusNodeMobile,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "الرجاء إدخال رقم الجوال";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodePassword.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                obscureText: _obscurePassword,
                focusNode: _focusNodePassword,
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
                    return "الرجاء إدخال كلمة مرور";
                  } else if (value.length < 8) {
                    return "يجب ان تكون كلمة المرور اكثر من 8 حروف";
                  }
                  return null;
                },
                onEditingComplete: () =>
                    _focusNodeConfirmPassword.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerConFirmPassword,
                obscureText: _obscurePassword,
                focusNode: _focusNodeConfirmPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
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
                    return "الرجاء إدخال كلمة مرور";
                  } else if (value != _controllerPassword.text) {
                    return "كلمة المرور غير متطابقة";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodeBankAcount.requestFocus(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerBankAcount,
                focusNode: _focusNodeBankAcount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Payment method",
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your cridet card number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: MainColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _boxAccounts.put(
                          _controllerUsername.text,
                          _controllerConFirmPassword.text,
                        );
                        signUp();

                        _formKey.currentState?.reset();

                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "SignUP",
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 15, color: MainColor),
                        ),
                      ),
                      const Text("<--You Have a Account"),
                    ],
                  ),
                  const SizedBox(height: 20),
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
    _focusNodeEmail.dispose();
    _focusNodeFirstName.dispose();
    _focusNodeSecondName.dispose();
    _focusNodeBD.dispose();
    _focusNodeBankAcount.dispose();

    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    _controllerUsername.dispose();
    _controllerFirstName.dispose();
    _controllerSecondName.dispose();
    _controllerBD.dispose();
    _controllerBankAcount.dispose();

    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConFirmPassword.dispose();
    super.dispose();
  }
}