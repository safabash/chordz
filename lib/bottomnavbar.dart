import 'package:flutter/material.dart';

import 'package:chordz_app/search.dart';
import 'package:chordz_app/playlist/playlist.dart';
import 'package:chordz_app/favorites.dart';
import 'package:chordz_app/home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List<Widget> pages = <Widget>[
    const Home(),
    const Favorite(),
    const Search(),
    const Playlist()
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 123, 90, 129),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 35),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  size: 35,
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 35),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_play_rounded, size: 35),
                label: 'Playlist',
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color.fromARGB(255, 241, 230, 240),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
