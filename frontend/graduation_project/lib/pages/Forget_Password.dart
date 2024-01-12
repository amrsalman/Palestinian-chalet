import 'package:flutter/material.dart';

const MainColor = Colors.redAccent; // Replace with your main color

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  // Implement reset password functionality.
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
