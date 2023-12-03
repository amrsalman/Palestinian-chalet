import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  final String text;
  final VoidCallback onClicked;
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => ElevatedButton(
    
    style: ElevatedButton.styleFrom(
      
      onPrimary: Colors.white,
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(horizontal:40 , vertical: 12 ),
      backgroundColor: Colors.redAccent,



    ),
    child: Text(text),
    onPressed: onClicked,
    

  );
}
