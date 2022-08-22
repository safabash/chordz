import 'package:chordz_app/privacy_policy.dart';
import 'package:chordz_app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';

import 'about.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            'Settings',
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
                child: Column(
              children: [
                ListTile(
                    title: Text(
                      'About',
                      style: Style.liststyle2,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const About()),
                      );
                    },
                    leading: const Icon(Icons.info, color: Colors.white)),
                ListTile(
                    title: Text(
                      'Share app',
                      style: Style.liststyle2,
                    ),
                    onTap: () async {
                      await Share.share('Share this App');
                    },
                    leading: const Icon(Icons.share, color: Colors.white)),
                ListTile(
                    title: Text(
                      'Reset app',
                      style: Style.liststyle2,
                    ),
                    onTap: () {
                      Restart.restartApp();
                    },
                    leading: const Icon(Icons.restore, color: Colors.white)),
                const SizedBox(height: 290),
                const Text(
                  'v 1.01',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ))));
  }
}
