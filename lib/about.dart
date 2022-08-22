import 'package:chordz_app/widgets/style.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'About',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'InriaSerif',
            ),
          ),
        ),
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 44, 8, 78),
                Color.fromARGB(135, 80, 48, 92),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )),
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Chordz application is created by software developer Safa Basheer at Brototype. The app promises a user friendly experience to the customers and highlights the simple and important features needed in a music player.',
                  style: Style.liststyle3,
                ),
              ),
            ))));
  }
}
