import 'package:chordz_app/view/playlist/inside_playlist.dart';
import 'package:chordz_app/model/musicplayer.dart';

import 'package:flutter/material.dart';
import 'package:chordz_app/view/widgets/glass.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../controller/database/playlist_db.dart';

class Playlist extends StatelessWidget {
  Playlist({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return ValueListenableBuilder(
        valueListenable: Hive.box<MusicPlayer>('playlistDB').listenable(),
        builder:
            (BuildContext context, Box<MusicPlayer> musicList, Widget? child) {
          return Scaffold(
              extendBody: true,
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: SizedBox(
                                    height: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Center(
                                            child: Text(
                                              'Create Your Playlist',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                controller: nameController,
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            ' Playlist Name'),
                                              )),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  width: 100.0,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  95,
                                                                  38,
                                                                  109)),
                                                      onPressed: () {
                                                        nameController.clear();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))),
                                              SizedBox(
                                                  width: 100.0,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  95,
                                                                  38,
                                                                  109)),
                                                      onPressed: () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          whenButtonClicked(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Save',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                      },
                      icon: const Icon(Icons.playlist_add))
                ],
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Playlist',
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
                  padding: const EdgeInsets.all(20),
                  child: SafeArea(
                    child: Hive.box<MusicPlayer>('playlistDB').isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  "assets /images/playlists.json",
                                  height: 300,
                                  width: 200,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Add your Playlist      ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: musicList.length,
                            itemBuilder: (context, index) {
                              final data = musicList.values.toList()[index];
                              return ValueListenableBuilder(
                                  valueListenable:
                                      Hive.box<MusicPlayer>('playlistDB')
                                          .listenable(),
                                  builder: (BuildContext context,
                                      Box<MusicPlayer> musicList,
                                      Widget? child) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return InsidePlaylist(
                                            playlist: data,
                                            folderindex: index,
                                          );
                                        }));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: GlassMorphism(
                                          end: 0.5,
                                          start: 0.1,
                                          child: Card(
                                            color: Colors.transparent,
                                            elevation: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: Lottie.asset(
                                                    'assets /images/playlists.json',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 4,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          // ignore: sized_box_for_whitespace
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data.name,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white60,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          flex: 1,
                                                          child: IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_outlined,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                              ),
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            'Delete Playlist'),
                                                                        content:
                                                                            const Text('Are you sure you want to delete this playlist?'),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            child:
                                                                                const Text('No'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            child:
                                                                                const Text('Yes'),
                                                                            onPressed:
                                                                                () {
                                                                              musicList.deleteAt(index);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                              }))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                  ),
                ),
              ));
        });
  }

  Future<void> whenButtonClicked(context) async {
    final name = nameController.text.trim();
    {}
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicPlayer(
        songIds: [],
        name: name,
      );
      Provider.of<PlaylistDB>(context, listen: false).playlistAdd(music);
      nameController.clear();
    }
  }
}
