import 'package:flutter/material.dart';

import '../../view/bottomnavbar.dart';

class ProviderSplash with ChangeNotifier {
  var text = Text(
    "Chordz",
    style: TextStyle(fontSize: 90.0, fontFamily: 'Pacifico', shadows: <Shadow>[
      Shadow(
          blurRadius: 18.0,
          color: Colors.white,
          offset: Offset.fromDirection(120, 12))
    ]),
  );
  Future<void> gotoHome(context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => BottomBar()));
  }
}
