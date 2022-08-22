import 'package:chordz_app/playing.dart';

import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';

import 'home.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  late List<SongModel> _allSongs;
  List<SongModel> _foundSongs = [];

  void loadAllSongList() async {
    _allSongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true);
    _foundSongs = _allSongs;
  }

  void search(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allSongs;
    } else {
      results = _allSongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundSongs = results;
    });
  }

  @override
  void initState() {
    loadAllSongList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 44, 8, 78),
            Color.fromARGB(135, 80, 48, 92),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )),
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  TextField(
                      onChanged: (value) => search(value),
                      decoration: const InputDecoration(
                        hintText: 'Search songs..',
                        focusColor: Colors.white,
                        filled: true,
                        fillColor: Color.fromARGB(255, 245, 242, 244),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      )),
                  Expanded(
                    child: _foundSongs.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: QueryArtworkWidget(
                                  id: _foundSongs[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note,
                                  ),
                                ),
                                title: Text(
                                  _foundSongs[index].displayNameWOExt,
                                ),
                                subtitle: Text(
                                  "${_foundSongs[index].artist}",
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            NowPlaying(playerSong: Home.song)),
                                  );
                                },
                              );
                            },
                            itemCount: _foundSongs.length)
                        : const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                  ),
                ],
              ),
            )));
  }
}
