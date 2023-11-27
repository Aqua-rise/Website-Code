// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questure/pages/content_page.dart';
import 'package:questure/pages/create_page.dart';
import 'package:questure/pages/library_page.dart';
import 'package:questure/pages/profile_page.dart';
import 'package:questure/pages/user_home_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // fire base sign out
  // final user = FirebaseAuth.instance.currentUser!;
  // sign user out method
  // void signUserOut() {
  //   FirebaseAuth.instance.signOut();
  // }

  // navigate around the bottom nav bar
  int _selectedIndex = 0;
  void _navigateBottomNavBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to navigate to
  final List<Widget> _pages = const [
    UserHomePage(),
    ContentPage(),
    CreatePage(),
    TrueHomeScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomNavBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/images/home.png',
              width: 25,
              height: 25,
              //color: Colors.pink,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/images/search.png',
              width: 30,
              height: 30,
              //color: Colors.pink,
            ),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/images/flash-card.png',
              width: 35,
              height: 35,
            ),
            label: 'Create!',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/images/folder.png',
              width: 33,
              height: 33,
            ),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/images/user.png',
              width: 28,
              height: 28,
              //color: Colors.pink,
            ),
            label: 'Profile',
          ),
        ],
      ),
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: signUserOut,
      //       icon: const Icon(Icons.logout),
      //     )
      //   ],
      // ),
    );
  }
}
