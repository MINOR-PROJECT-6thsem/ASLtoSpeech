import 'package:flutter/material.dart';
import 'package:handly/loginp.dart';
import 'package:handly/signup.dart';

class authpage extends StatefulWidget {
  
  const authpage({super.key});

  @override
  State<authpage> createState() => _authpageState();
}

class _authpageState extends State<authpage> {
  @override
  bool loginpage = true;
  void toggleScreens(){
   setState(() {
     loginpage = !loginpage;
   });
  }
  Widget build(BuildContext context) {
    if (loginpage) {
      return loginS(signuppage: toggleScreens, title: '', );
    } else {
      return signs(loginpage: toggleScreens, title: '',);
    }
  }
}
