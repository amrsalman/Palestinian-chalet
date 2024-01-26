import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       Container(
        
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:AssetImage("assets/images/img5.jpg"),
            fit: BoxFit.cover,
             )

        ),
        
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.center ,
          children: [
                 ElevatedButton(
                  
                  onPressed: () {
                  Navigator.pushNamed(context, '/login');
              // Navigate to the second screen when tapped.
            },
            child: const Text('User Login' ,style: TextStyle(fontSize: 25)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 99, vertical: 15)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(66)))




            ),
            
            
          ),
          //  SizedBox(height: 20,),
          //  ElevatedButton(
          //         onPressed: () {
          //         Navigator.pushNamed(context, '/Admin');
          //     // Navigate to the second screen when tapped.
          //   },
          //   child: const Text('Admin Login' ,style: TextStyle(fontSize: 22),),
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all(Colors.redAccent),
          //     padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 95, vertical: 15)),
          //     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(66)))




          //   ),
          //  ),
          SizedBox(height: 20,),
            ElevatedButton(
                  onPressed: () {
                  Navigator.pushNamed(context, '/signup');
              // Navigate to the second screen when tapped.
            },
            child: const Text('Sign up ' ,style: TextStyle(fontSize: 25),),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 110, vertical: 15)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(66)))




            ),
           ),

          ],
          
          
             
             
          
             ),
       ),
      

    );
  }
}
