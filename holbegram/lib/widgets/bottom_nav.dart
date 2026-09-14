import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import '../screens/pages/add_image.dart';
import '../screens/pages/favorite.dart';
import '../screens/pages/feed.dart';
import '../screens/pages/profile_screen.dart';
import '../screens/pages/search.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const [
          Feed(),
          Search(),
          AddImage(),
          Favorite(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });

          _pageController.animateToPage(
            index,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.ease,
          );
        },
        items: [
          BottomNavyBarItem(
            icon: const Icon(
              Icons.home,
            ),
            title: const Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.search,
            ),
            title: const Text(
              'Search',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.add_circle_outline,
            ),
            title: const Text(
              'Add',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.favorite_border,
            ),
            title: const Text(
              'Favorite',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.person_outline,
            ),
            title: const Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
