import 'package:chordz_app/controller/database/playlist_db.dart';
import 'package:chordz_app/view/widgets/songstore.dart';
import 'package:chordz_app/view//widgets/style.dart';
import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../model/musicplayer.dart';

class AddSongs extends StatelessWidget {
  AddSongs({Key? key, required this.playlist}) : super(key: key);
  final MusicPlayer playlist;
  static List<SongModel> song = [];
  @override
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
              // setState(() {});
            }),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Add Songs',
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
            AddSongs.song = item.data!;

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
                      trailing: Consumer(
                        builder: (BuildContext context, PlaylistDB value,
                            Widget? child) {
                          return IconButton(
                            onPressed: () {
                              playlistCheck(item.data![index], context);
                            },
                            icon: !playlist.isValueIn(item.data![index].id)
                                ? const Icon(
                                    Icons.add,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  )
                                : const Icon(Icons.check, color: Colors.white),
                          );
                        },
                      )),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 15),
                  itemCount: item.data!.length,
                ));
          },
        ),
      ),
    );
  }

  void playlistCheck(SongModel data, context) {
    if (!playlist.isValueIn(data.id)) {
      playlist.add(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Added to Playlist',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(milliseconds: 250));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      playlist.deleteData(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Removed from Playlist',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(milliseconds: 250));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
