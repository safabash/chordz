import 'package:chordz_app/model/musicplayer.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../view/splash_screen.dart';

class PlaylistDB with ChangeNotifier {
  List<MusicPlayer> playlistDbNotifier = [];

  Future<void> playlistAdd(MusicPlayer value) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    await playlistDb.add(value);
    playlistDbNotifier.add(value);
    refresh();
    notifyListeners();
  }

  Future<void> refresh() async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    playlistDbNotifier.clear();
    playlistDbNotifier.addAll(playlistDb.values);
    notifyListeners();
  }

  Future<void> playlistDelete(int index) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    await playlistDb.deleteAt(index);
    refresh();
    notifyListeners();
  }

  Future<void> appReset(context) async {
    final playListDb = Hive.box<MusicPlayer>('playlistDB');
    final musicDb = Hive.box<int>('favoriteDB');
    await musicDb.clear();
    await playListDb.clear();
    musicDb.clear();
    notifyListeners();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false);
    notifyListeners();
  }
}
