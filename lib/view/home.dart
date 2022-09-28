import 'package:chordz_app/view/playing.dart';
import 'package:chordz_app/view/settings/settings.dart';
import 'package:chordz_app/view/widgets/songstore.dart';
import 'package:chordz_app/view/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controller/database/favorite_db.dart';
import '../controller/provider/home_provider.dart';
import 'favorites/favorite_btn.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderHome>(context, listen: false).requestPermission();
    });
    FocusManager.instance.primaryFocus?.unfocus();
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
          future: Provider.of<ProviderHome>(context, listen: false)
              .audioQuery
              .querySongs(
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
            ProviderHome.song = item.data!;
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
                    trailing: FavoriteBut(song: ProviderHome.song[index]),
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
