import 'package:chordz_app/controller/database/favorite_db.dart';
import 'package:chordz_app/view/widgets/style.dart';
import 'package:flutter/material.dart';

import 'package:chordz_app/view/playing.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:chordz_app/view/widgets/songstore.dart';

class Favorite extends StatelessWidget {
  const Favorite({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    return ValueListenableBuilder(
        valueListenable: FavoriteDB.favoriteSongs,
        builder: (BuildContext ctx, List<SongModel> favorData, Widget? child) {
          return Scaffold(
              extendBody: true,
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Favorite',
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FavoriteDB.favoriteSongs.value.isEmpty
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets /images/fav.json',
                              height: 200,
                              width: 200,
                            ),
                            const Text(
                              'No favorites yet',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                      : ValueListenableBuilder(
                          valueListenable: FavoriteDB.favoriteSongs,
                          builder: (BuildContext ctx, List<SongModel> favorData,
                              Widget? child) {
                            return ListView.separated(
                              itemBuilder: (context, index) => ListTile(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                tileColor:
                                    const Color.fromARGB(255, 224, 128, 220),
                                textColor:
                                    const Color.fromARGB(115, 233, 223, 223),
                                leading: QueryArtworkWidget(
                                  id: favorData[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget:
                                      const Icon(Icons.music_note),
                                ),
                                title: Text(
                                  favorData[index].displayNameWOExt,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  style: Style.liststyle,
                                ),
                                subtitle: Text(
                                  "${favorData[index].artist}",
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      FavoriteDB.favoriteSongs
                                          .notifyListeners();
                                      FavoriteDB.delete(favorData[index].id);

                                      const snackbar = SnackBar(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                          content: Text(
                                            'Song deleted from favorite',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          duration:
                                              Duration(microseconds: 3000));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    },
                                    icon: const Icon(
                                      Icons.heart_broken_sharp,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                onTap: () {
                                  List<SongModel> newlist = [...favorData];

                                  GetSongs.player.stop();
                                  GetSongs.player.setAudioSource(
                                      GetSongs.createSongList(newlist),
                                      initialIndex: index);
                                  GetSongs.player.play();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => NowPlaying(
                                            playerSong: newlist,
                                          )));
                                },
                              ),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(height: 15),
                              itemCount: favorData.length,
                            );
                          }),
                ),
              ));
        });
  }
}
