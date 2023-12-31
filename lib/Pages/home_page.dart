// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:questure/Pages/create_page.dart';
import 'package:questure/Pages/library_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // fire base sign out
  // final user = FirebaseAuth.instance.currentUser!;
  // sign user out method
  // void signUserOut() {
  //   FirebaseAuth.instance.signOut();
  // }

  // navigate around the bottom nav bar
  // Index 3 makes the app start at the folders page
  int _selectedIndex = 1;
  void _navigateBottomNavBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to navigate to
  final List<Widget> _pages = const [
    // UserHomePage(),
    // ContentPage(),
    CreatePage(),
    TrueHomeScreen(), // Renamed from library_page
    // ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomNavBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.home),
          //   label: 'Home',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.public),
          //   label: 'Browse',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_to_photos,
              size: 40,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
              size: 40,
            ),
            label: 'My Folders',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
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
