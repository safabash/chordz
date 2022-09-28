import 'package:chordz_app/controller/database/playlist_db.dart';
import 'package:chordz_app/controller/provider/bottom_nav_bar_provider.dart';
import 'package:chordz_app/controller/provider/home_provider.dart';
import 'package:chordz_app/controller/provider/now_playing_provider.dart';
import 'package:chordz_app/controller/provider/search_provider.dart';
import 'package:chordz_app/controller/provider/splash_provider.dart';
import 'package:chordz_app/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:chordz_app/model/musicplayer.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //set database initialise
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicPlayerAdapter().typeId)) {
    //adapter registered
    Hive.registerAdapter(MusicPlayerAdapter());
  }

  await Hive.openBox<int>('favoriteDB');
  await Hive.openBox<MusicPlayer>('playlistDB');
  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      preloadArtwork: true);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ProviderSplash>(create: (_) => ProviderSplash()),
    ChangeNotifierProvider<ProviderHome>(create: (_) => ProviderHome()),
    ChangeNotifierProvider<ProviderBottomNavBar>(
        create: (_) => ProviderBottomNavBar()),
    ChangeNotifierProvider<ProviderNowPlaying>(
        create: (_) => ProviderNowPlaying()),
    ChangeNotifierProvider<ProviderSearch>(create: (_) => ProviderSearch()),
    ChangeNotifierProvider<PlaylistDB>(create: (_) => PlaylistDB())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chordz app',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
