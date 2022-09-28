import 'package:flutter/material.dart';

class ProviderNowPlaying with ChangeNotifier {
  int currentIndex = 0;
  bool isPlaying = true;

  mountFunction(index) {
    if (index != null) {
      currentIndex = index!;
    }
    notifyListeners();
  }

  void listen() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  Future<void> nextSong() async {
    notifyListeners();
  }
}
