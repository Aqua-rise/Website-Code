import 'package:flutter/material.dart';
import 'package:questure/components/my_button.dart';
import 'package:questure/components/my_description_box.dart';
import 'package:questure/components/my_smaller_button.dart';
import 'package:questure/components/my_textfield.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final subjectController = TextEditingController();

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
      body: Padding(
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
              controller: nameController,
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
              controller: descriptionController,
              hintText: 'Flashcards for Software Dev...',
            ),
            const SizedBox(height: 5),

            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Add a description.',
                style: TextStyle(
                  //fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            const SizedBox(height: 20),

            MyTextField(
              controller: subjectController,
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
                      Navigator.pushNamed(context, '/home_page');
                      }, 
                    text: 'Viewing',
                    ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            MyButton(
              onTap: () {
                Navigator.pushNamed(context, '/home_page');
              },
              text: 'Create Set')
          ],
        ),
      ),
    );
  }
}
