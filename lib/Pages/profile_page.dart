import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // fire base sign out
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      // appBar: AppBar(

      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: const Row(
      //     children: [
      //       Text(
      //         'Questure',
      //         style: TextStyle(color: Colors.black),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
