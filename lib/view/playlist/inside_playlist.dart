import 'package:chordz_app/view/playlist/add_songs.dart';

import 'package:chordz_app/view/playing.dart';
import 'package:chordz_app/view/widgets/songstore.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../controller/database/playlist_db.dart';
import '../../model/musicplayer.dart';

class InsidePlaylist extends StatelessWidget {
  InsidePlaylist({Key? key, required this.playlist, required this.folderindex})
      : super(key: key);
  final MusicPlayer playlist;
  final int folderindex;

  late List<SongModel> playlistsong;
  @override
  Widget build(BuildContext context) {
    Provider.of<PlaylistDB>(context, listen: false).refresh();
    return Consumer(
      builder: (BuildContext context, PlaylistDB value, Widget? child) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop()),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              playlist.name,
              style: const TextStyle(
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
            child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<MusicPlayer>('playlistDB').listenable(),
                builder: (BuildContext context, Box<MusicPlayer> value,
                    Widget? child) {
                  playlistsong =
                      listPlaylist(value.values.toList()[folderindex].songIds);
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: playlistsong.isEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets /images/add_playlsit.json',
                                height: 200,
                                width: 200,
                              ),
                              const Text(
                                'Add to your playlist',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              return ListTile(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  tileColor:
                                      const Color.fromARGB(255, 224, 128, 220),
                                  textColor:
                                      const Color.fromARGB(115, 233, 223, 223),
                                  leading: QueryArtworkWidget(
                                    id: playlistsong[index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: const Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                    ),
                                    errorBuilder: (context, excepion, gdb) {
                                      // setState(() {});
                                      return Image.asset('');
                                    },
                                  ),
                                  title: Text(
                                    playlistsong[index].title,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    playlistsong[index].artist!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      playlist
                                          .deleteData(playlistsong[index].id);
                                      const snackbar = SnackBar(
                                          backgroundColor: Colors.black,
                                          content: Text(
                                            'Deleted from playlist',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    List<SongModel> newlist = [...playlistsong];

                                    GetSongs.player.stop();
                                    GetSongs.player.setAudioSource(
                                        GetSongs.createSongList(newlist),
                                        initialIndex: index);
                                    GetSongs.player.play();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (ctx) => NowPlaying(
                                                  playerSong: playlistsong,
                                                )));
                                  });
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(height: 15),
                            itemCount: playlistsong.length,
                          ),
                  );
                }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AddSongs(
                        playlist: playlist,
                      )));
            },
            backgroundColor: const Color.fromARGB(255, 167, 76, 175),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetSongs.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songscopy[i].id == data[j]) {
          plsongs.add(GetSongs.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
