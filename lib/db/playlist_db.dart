import 'package:chordz_app/model/musicplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlaylistDB {
  static ValueNotifier<List<MusicPlayer>> playlistDbNotifier =
      ValueNotifier([]);

  static Future<void> playlistAdd(MusicPlayer value) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    await playlistDb.add(value);
    playlistDbNotifier.value.add(value);
  }

  static Future<void> refresh() async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    playlistDbNotifier.value.clear();
    playlistDbNotifier.value.addAll(playlistDb.values);
  }

  static Future<void> playlistDelete(int index) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    await playlistDb.deleteAt(index);
    refresh();
  }
}
