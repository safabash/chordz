import 'package:chordz_app/controller/provider/bottom_nav_bar_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Consumer<ProviderBottomNavBar>(builder: (context, values, child) {
        return values.pages[values.selectedIndex];
      }),
      bottomNavigationBar:
          Consumer<ProviderBottomNavBar>(builder: ((context, value, child) {
        return SizedBox(
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
              currentIndex: value.selectedIndex,
              selectedItemColor: const Color.fromARGB(255, 241, 230, 240),
              onTap: (index) => value.onItemTapped(index),
            ),
          ),
        );
      })),
    );
  }
}
