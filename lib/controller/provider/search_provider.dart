import 'package:chordz_app/controller/provider/home_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ProviderSearch extends ChangeNotifier {
  List<SongModel> foundSongs = [];
  final audioquery = OnAudioQuery();
  List<SongModel> allSong = [];
  Future<List<SongModel>> loadAllSongList() async {
    allSong = await audioquery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    foundSongs = allSong;
    return foundSongs;
  }

  Future<void> search(String enteredKeyword) async {
    final a = await loadAllSongList();
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = a;
    } else {
      results = a
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    foundSongs = results;

    notifyListeners();
  }
}
