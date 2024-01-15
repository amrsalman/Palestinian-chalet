import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const MainColor = Colors.redAccent;

class ForgotPasswordPage extends StatelessWidget {
  int x = 1; 
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    Future<void> sendPasswordResetEmail(String email) async {
      final Uri uri = Uri.parse('http://10.0.2.2:8080/api/v1/user/reset-password');

      try {
        final response = await http.post(
          uri,
          body: {'email': email},
        );

        if (response.statusCode == 200) {
          print('Password reset email sent successfully.');
        } else {
          x = 0;
          print('Failed to send password reset email. Status code: ${response.statusCode}');
        }
      } catch (error) {
        x = 0;
        print('Error sending password reset email: $error');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Your Password ', style: TextStyle(color: MainColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: MainColor),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/images/Lock-Icon1.png'), // Add your lock icon asset
                  ),
                ),
              ),
              SizedBox(height: 48.0),
              Text(
                'Enter your email and we will send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 24.0),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                child: Text('Reset Your Password '),
                onPressed: () async {
                  // استدعاء الدالة التي تقوم بإرسال البريد الإلكتروني لإعادة تعيين كلمة المرور
                  await sendPasswordResetEmail(emailController.text);

                  // يمكنك أيضًا إضافة رسالة تأكيد إلى المستخدم
                  if(x == 1){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Password Reset Email Sent'),
                        content: Text('We sent you an email with instructions to reset your password.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                   );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Failed to send the password reset email.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                                
                },
                style: ElevatedButton.styleFrom(
                  primary: MainColor, // background
                  onPrimary: Colors.white, // foreground
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
