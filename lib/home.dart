import 'package:chordz_app/db/favorite_db.dart';
import 'package:chordz_app/playing.dart';
import 'package:chordz_app/settings.dart';
import 'package:chordz_app/widgets/songstore.dart';
import 'package:chordz_app/widgets/style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'db/favorite_btn.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static List<SongModel> song = [];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    await Permission.storage.request();
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
              icon: const Icon(Icons.settings_outlined))
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Library',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'InriaSerif',
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 44, 8, 78),
            Color.fromARGB(135, 80, 48, 92),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )),
        child: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(child: Text('No Songs Found'));
            }
            Home.song = item.data!;
            if (!FavoriteDB.isInitialized) {
              FavoriteDB.initialise(item.data!);
            }

            GetSongs.songscopy = item.data!;
            return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    tileColor: const Color.fromARGB(255, 224, 128, 220),
                    textColor: const Color.fromARGB(115, 233, 223, 223),
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(Icons.music_note),
                    ),
                    title: Text(
                      item.data![index].displayNameWOExt,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: Style.liststyle,
                    ),
                    subtitle: Text(
                      "${item.data![index].artist}",
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    trailing: FavoriteBut(song: Home.song[index]),
                    onTap: () {
                      GetSongs.player.setAudioSource(
                          GetSongs.createSongList(item.data!),
                          initialIndex: index);
                      GetSongs.player.play();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NowPlaying(
                                    playerSong: item.data!,
                                  )));
                    },
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 15),
                  itemCount: item.data!.length,
                ));
          },
        ),
      ),
    );
  }
}
