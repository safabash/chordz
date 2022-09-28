import 'package:flutter/material.dart';

import '../../view/favorites/favorites.dart';
import '../../view/home.dart';
import '../../view/playlist/playlist.dart';
import '../../view/search.dart';

class ProviderBottomNavBar with ChangeNotifier {
  List<Widget> pages = <Widget>[
    const Home(),
    const Favorite(),
    const Search(),
    Playlist()
  ];
  int selectedIndex = 0;
  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
