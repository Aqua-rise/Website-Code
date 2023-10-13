import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 20,
          ),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: Colors.black,
            tabBackgroundColor: Colors.white,
            gap: 8,
            // onTabChange:
            padding: EdgeInsets.all(10),
            tabs: [
              GButton(
                icon: Icons.home_rounded,
                iconActiveColor: Color.fromARGB(255, 37, 201, 94),
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite_outline,
                iconActiveColor: Color.fromARGB(255, 236, 69, 125),
                text: 'Likes',
              ),
              GButton(
                icon: Icons.add_to_photos_rounded,
                iconActiveColor: Colors.lightBlue,
                text: 'Create Set',
              ),
              GButton(
                icon: Icons.menu_rounded,
                iconActiveColor: Color.fromARGB(255, 221, 205, 63),
                text: 'Menu',
              ),
            ],
          ),
        ),
      ),

      // body: Center(
      //   child: Text(
      //     "LOGGED IN AS: " + user.email!,
      //     style: const TextStyle(
      //       fontSize: 20,
      //     ),
      //   ),
      // ),
    );
  }
}
