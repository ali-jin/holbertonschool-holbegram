import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import '../screens/Pages/feed.dart';
import '../screens/Pages/search.dart';
import '../screens/Pages/add_image.dart';
import '../screens/Pages/favorite.dart';
import '../screens/Pages/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

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

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: PageView(
          controller: _pageController,
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
          onItemSelected: onPageChanged,
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text(
                'Feed',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Billabong',
                ),
              ),
              activeColor: Colors.red,
              textAlign: TextAlign.center,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.search),
              title: const Text(
                'Search',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Billabong',
                ),
              ),
              activeColor: Colors.red,
              textAlign: TextAlign.center,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.add),
              title: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Billabong',
                ),
              ),
              activeColor: Colors.red,
              textAlign: TextAlign.center,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.favorite),
              title: const Text(
                'Favorite',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Billabong',
                ),
              ),
              activeColor: Colors.red,
              textAlign: TextAlign.center,
              inactiveColor: Colors.black,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Billabong',
                ),
              ),
              activeColor: Colors.red,
              textAlign: TextAlign.center,
              inactiveColor: Colors.black,
            ),
          ],
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
