import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handly/asltotext.dart';

class scr extends StatefulWidget {
  scr({super.key, required String title});

  @override
  State<scr> createState() => _scrState();
}

class _scrState extends State<scr> {
  @override
  Future<String> _getname() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is null');
      return '';
    }
    final uid = user.uid;
    print('UID: $uid');

    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String name = documentSnapshot.get('name');
    print('Name: $name');
    return name;
  }

  Widget name() {
    return FutureBuilder<String>(
      future: _getname(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final name = snapshot.data!;
          return Container(
            child: Text(
              "Welcome, $name!",
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
            "Error retrieving name: ${snapshot.error}",
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return const Text(
            'Loading...',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }

  Widget asltos() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purpleAccent,
                      Colors.pinkAccent,
                    ],
                  ),
                ),
                child: IconButton(
                  icon: Row(
                    children: [
                      Icon(
                        Icons.record_voice_over_sharp,
                        size: 70,
                        color: Colors.white,
                      ),
                      SizedBox(
                          width:
                              20), // Add some spacing between the icon and text
                      Text(
                        'ASL to Speech',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    // code for ASL to speech
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget asltot() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purpleAccent,
                        Colors.pinkAccent,
                      ],
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    icon: Row(
                      children: [
                        Icon(
                          Icons.translate_sharp,
                          size: 70,
                          color: Colors.white,
                        ),
                        const SizedBox(
                            width:
                                20), // Add some spacing between the icon and text
                        Text(
                          'ASL to Text',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => aslto()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_sharp),
              color: Colors.white,
              alignment: Alignment.topRight,
              iconSize: 40,
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 236, 234, 237),
                  Color(0xffff4590),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 25),
                  child: Text(
                    "Handly",
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 2,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 25),
                  child: name(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffff4590),
                    Color(0xff382743),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(25.0, 150.0, 25.0, 25.0),
              ),
            ),
            Positioned(
              top: 250.0,
              left: 0.0,
              right: 0.0,
              child: asltos(),
            ),
            SizedBox(height: 20.0),
            Positioned(
              top: 450.0,
              left: 0.0,
              right: 0.0,
              child: asltot(),
            ),
          ],
        ),
      ),
    );
  }
}
