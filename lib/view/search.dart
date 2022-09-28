import 'package:chordz_app/controller/provider/search_provider.dart';

import 'package:chordz_app/view/playing.dart';
import 'package:chordz_app/view/widgets/songstore.dart';

import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controller/provider/home_provider.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<ProviderSearch>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await searchProvider.loadAllSongList();
      await searchProvider.search('');
    });
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
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
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                        onChanged: (value) =>
                            Provider.of<ProviderSearch>(context, listen: false)
                                .search(value),
                        decoration: const InputDecoration(
                          hintText: 'Search songs..',
                          focusColor: Colors.white,
                          filled: true,
                          fillColor: Color.fromARGB(255, 245, 242, 244),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(children: [
                      Consumer<ProviderSearch>(
                          builder: (context, value, child) {
                        if (value.foundSongs.isEmpty) {
                          return const Center(
                            child: Text('No songs'),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final data = value.foundSongs[index];
                            return ListTile(
                              leading: QueryArtworkWidget(
                                keepOldArtwork: true,
                                id: data.id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                ),
                              ),
                              title: Text(
                                data.displayNameWOExt,
                              ),
                              subtitle: Text(
                                "${data.artist}",
                              ),
                              onTap: () {
                                final searchIndex = creatSearchIndex(data);
                                FocusScope.of(context).unfocus();
                                GetSongs.player.setAudioSource(
                                    GetSongs.createSongList(ProviderHome.song),
                                    initialIndex: searchIndex);
                                GetSongs.player.play();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => NowPlaying(
                                        playerSong: ProviderHome.song),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: value.foundSongs.length,
                          separatorBuilder: (context, index) => const Divider(),
                        );
                      })
                    ]),
                  ],
                ),
              ),
            )));
  }

  int? creatSearchIndex(SongModel data) {
    for (int i = 0; i < ProviderHome.song.length; i++) {
      if (data.id == ProviderHome.song[i].id) {
        return i;
      }
    }
    return null;
  }
}
