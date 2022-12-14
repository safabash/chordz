import 'package:chordz_app/controller/provider/now_playing_provider.dart';
import 'package:chordz_app/view/widgets/songstore.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'favorites/favorite_btn.dart';

class NowPlaying extends StatelessWidget {
  NowPlaying({
    Key? key,
    required this.playerSong,
  }) : super(key: key);
  List<SongModel> playerSong;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderNowPlaying>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GetSongs.player.currentIndexStream.listen((index) {
        provider.mountFunction(index);
      });
    });
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // ignore: prefer_const_constructors
          title: Text(
            textAlign: TextAlign.center,
            'Now playing',
            style: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'InriaSerif',
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: RadialGradient(
              colors: [
                Color.fromARGB(255, 44, 8, 78),
                Color.fromARGB(134, 113, 74, 128),
              ],
              radius: 1,
            )),
            child: Column(
              children: [
                const SizedBox(height: 70),
                Consumer(
                  builder: (BuildContext context, ProviderNowPlaying value,
                      Widget? child) {
                    return QueryArtworkWidget(
                      keepOldArtwork: true,
                      quality: 100,
                      artworkBorder: BorderRadius.circular(100),
                      nullArtworkWidget: const CircleAvatar(
                        radius: 120,
                        backgroundColor: Color.fromARGB(255, 109, 44, 134),
                        child: Icon(
                          Icons.music_note,
                          size: 100,
                        ),
                      ),
                      id: playerSong[value.currentIndex].id,
                      type: ArtworkType.AUDIO,
                      artworkFit: BoxFit.cover,
                      artworkWidth: 200,
                      artworkHeight: 200,
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer(
                  builder: (BuildContext context, ProviderNowPlaying value,
                      Widget? child) {
                    return Column(
                      children: [
                        Text(
                          playerSong[value.currentIndex].displayNameWOExt,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: 'Pacifico'),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          playerSong[value.currentIndex].artist.toString() ==
                                  "<unknown>"
                              ? "Unknown Artist"
                              : playerSong[value.currentIndex]
                                  .artist
                                  .toString(),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Pacifico'),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<DurationState>(
                      stream: _durationStateStream,
                      builder: (context, snapshot) {
                        final durationState = snapshot.data;
                        final progress =
                            durationState?.position ?? Duration.zero;
                        final total = durationState?.total ?? Duration.zero;
                        return ProgressBar(
                            timeLabelTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            progress: progress,
                            total: total,
                            barHeight: 4.0,
                            thumbRadius: 7,
                            progressBarColor:
                                const Color.fromARGB(255, 149, 167, 232),
                            thumbColor:
                                const Color.fromARGB(255, 149, 167, 232),
                            baseBarColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            bufferedBarColor:
                                const Color.fromARGB(255, 253, 254, 255),
                            buffered: const Duration(milliseconds: 2000),
                            onSeek: (duration) {
                              GetSongs.player.seek(duration);
                            });
                      }),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<bool>(
                      stream: GetSongs.player.shuffleModeEnabledStream,
                      builder: (context, snapshot) {
                        return _shuffleButton(context, snapshot.data ?? false);
                      },
                    ),
                    IconButton(
                        onPressed: () async {
                          if (GetSongs.player.hasPrevious) {
                            provider.isPlaying = true;
                            await GetSongs.player.seekToPrevious();
                            await GetSongs.player.play();
                          } else {
                            await GetSongs.player.play();
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          size: 40,
                          color: Colors.white,
                        )),
                    Consumer<ProviderNowPlaying>(
                        builder: (BuildContext context, value, Widget? child) {
                      return FloatingActionButton(
                        onPressed: () {
                          if (value.isPlaying) {
                            value.isPlaying = true;
                            GetSongs.player.pause();
                          } else {
                            GetSongs.player.play();
                            value.isPlaying = false;
                          }
                          value.listen();
                        },
                        hoverColor: Colors.white,
                        backgroundColor: Colors.black,
                        elevation: 0.0,
                        child: value.isPlaying == true
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow_rounded),
                      );
                    }),
                    IconButton(
                      onPressed: () async {
                        if (GetSongs.player.hasNext) {
                          provider.isPlaying = true;
                          await GetSongs.player.seekToNext();
                          await GetSongs.player.play();
                        } else {
                          await GetSongs.player.play();
                        }
                      },
                      icon: const Icon(Icons.skip_next,
                          size: 40, color: Colors.white),
                    ),
                    StreamBuilder<LoopMode>(
                      stream: GetSongs.player.loopModeStream,
                      builder: (context, snapshot) {
                        return _repeatButton(
                            context, snapshot.data ?? LoopMode.off);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FavoriteBut(song: playerSong[provider.currentIndex]),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(minutes: seconds);
    GetSongs.player.seek(duration);
  }
}

Widget _shuffleButton(BuildContext context, bool isEnabled) {
  return IconButton(
    icon: isEnabled
        ? const Icon(Icons.shuffle, color: Colors.white)
        : const Icon(
            Icons.shuffle,
            color: Color.fromARGB(255, 179, 149, 192),
          ),
    onPressed: () async {
      final enable = !isEnabled;
      if (enable) {
        await GetSongs.player.shuffle();
      }
      await GetSongs.player.setShuffleModeEnabled(enable);
    },
  );
}

Widget _repeatButton(BuildContext context, LoopMode loopMode) {
  final icons = [
    const Icon(Icons.repeat, color: Color.fromARGB(255, 179, 149, 192)),
    const Icon(Icons.repeat, color: Colors.white),
    const Icon(Icons.repeat_one, color: Colors.white),
  ];
  const cycleModes = [
    LoopMode.off,
    LoopMode.all,
    LoopMode.one,
  ];
  final index = cycleModes.indexOf(loopMode);
  return IconButton(
    icon: icons[index],
    onPressed: () {
      GetSongs.player.setLoopMode(
          cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
    },
  );
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}

Stream<DurationState> get _durationStateStream =>
    Rx.combineLatest2<Duration, Duration?, DurationState>(
        GetSongs.player.positionStream,
        GetSongs.player.durationStream,
        (position, duration) => DurationState(
            position: position, total: duration ?? Duration.zero));
