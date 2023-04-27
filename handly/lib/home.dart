import 'package:flutter/material.dart';
import 'package:handly/main_page.dart';

class handly extends StatefulWidget {
  const handly({super.key});

  @override
  State<handly> createState() => _handlyState();
}

class _handlyState extends State<handly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xffff4590),
                  Color(0xff382743),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                bottom: 250,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/logo1.png',
                      width: 500,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'HANDLY',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainPage(
                                      title: '',
                                    )));
                      },
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 196, 67, 110),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: const Center(
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
