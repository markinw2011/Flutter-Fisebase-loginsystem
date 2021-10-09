import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class WelcomeScreen extends StatelessWidget {
  final  auth =FirebaseAuth.instance;

   WelcomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(title: const Text("ยินดีต้อนรับเข้าสู่ระบบ"),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Text(auth.currentUser!.email.toString(),style: TextStyle(fontSize: 20),),
              ElevatedButton(
                 child: Text("ออกจากระบบ"),
                 onPressed:(){
                  auth.signOut().then((value){
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                    return  HomeScreen();
                    }));
                  });
                },
                 )
            ],),
        ),
      ),
    );
  }
}