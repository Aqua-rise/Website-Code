import 'package:flutter/material.dart';
import 'package:questure/components/my_button.dart';
import 'package:questure/components/my_description_box.dart';
import 'package:questure/components/my_smaller_button.dart';
import 'package:questure/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:questure/Pages/library_page.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final folderNameController = TextEditingController();
  final folderDescriptionController = TextEditingController();
  final folderSubjectController = TextEditingController();
  var isPublicBool = false;
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Questure',
              style: TextStyle(
                color: Colors.black,
                //fontSize: 25,
              ),
            ),
            const SizedBox(width: 85),
            Image.asset(
              'lib/images/quiz.png',
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'Create a Study Set',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                MyTextField(
                  controller: folderNameController,
                  hintText: 'E.g. UI/UX Differences',
                  obscureText: false,
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    'Name your set!',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyDescriptionBox(
                  controller: folderDescriptionController,
                  hintText: 'Flashcards for Software Dev...',
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    'Add a description (optional)',
                    style: TextStyle(
                      //fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: folderSubjectController,
                  hintText: 'Other',
                  obscureText: false,
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    'What subject is your study set related to or in.',
                    style: TextStyle(
                      //fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: MySmallerButton(
                        onTap: () {
                          setState(() {
                            isPublicBool = !isPublicBool;
                          });
                        },
                        text: isPublicBool ? 'Public' : 'Private',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                MyButton(
                    onTap: () async {
                      if (folderNameController.text.trim().isNotEmpty &&
                          folderDescriptionController.text.trim().isNotEmpty) {
                        await firestoreService.createFolder(
                            folderNameController.text.trim(),
                            folderDescriptionController.text.trim(),
                            folderSubjectController.text.trim(),
                            isPublicBool);

                        folderNameController.clear();
                        folderDescriptionController.clear();
                        folderSubjectController.clear();
                        Navigator.of(context).pop(
                          MaterialPageRoute(
                            builder: (context) => const TrueHomeScreen(),
                          ),
                        );
                      }
                    },
                    text: 'Create Set')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createFolder(String folderName, String folderDescription,
      String folderSubject, bool isPublic) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('folders')
          .add({
        'name': folderName,
        'description': folderDescription,
        'subject': folderSubject,
        'isPublic': isPublic,
      });
    }
  }
}
