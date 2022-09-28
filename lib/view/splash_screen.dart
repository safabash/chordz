

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

import '../controller/provider/splash_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProviderSplash>(context, listen: false).gotoHome(context);

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
            child: Provider.of<ProviderSplash>(context, listen: false).text),
      ),
    );
  }
}
