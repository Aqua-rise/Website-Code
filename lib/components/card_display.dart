import 'package:flutter/material.dart';
import 'package:questure/notifiers/flashcard_notifier.dart';
import 'package:provider/provider.dart';

class CardDisplay extends StatelessWidget {
  const CardDisplay({
    required this.isQuestion,
    Key? key,
  }) : super(key: key);

  final bool isQuestion;

//Implementation for questions and answers appearing on cards would go here
@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),

    );
  }

Expanded buildTextBox(String text, BuildContext context, int flex) {
  return Expanded(
      flex: flex,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ));
  }
}
