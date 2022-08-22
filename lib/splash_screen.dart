import 'package:chordz_app/bottomnavbar.dart';

import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = Text(
      "Chordz",
      style:
          TextStyle(fontSize: 90.0, fontFamily: 'Pacifico', shadows: <Shadow>[
        Shadow(
            blurRadius: 18.0,
            color: Colors.white,
            offset: Offset.fromDirection(120, 12))
      ]),
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 224, 217, 229),
            Color.fromARGB(134, 149, 85, 173),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )),
        alignment: Alignment.center,
        child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 88, 25, 95),
            highlightColor: const Color.fromARGB(135, 111, 79, 155),
            child: text),
      ),
    );
  }

  Future<void> gotoHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const BottomBar()));
  }
}
