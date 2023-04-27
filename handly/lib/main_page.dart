import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'auth.dart';
import 'screen.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key, required String title});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return  scr(
                  title: '',
                );
              } else {
                return  authpage();
              }
            }));
  }
}
