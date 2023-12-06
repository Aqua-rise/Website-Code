import 'package:flutter/material.dart';
import 'package:questure/app/guide_box.dart';
import 'package:questure/app/quick_box.dart';
import 'package:questure/notifiers/flashcard_notifier.dart';
import 'package:questure/pages/flashcards_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

loadSession({required BuildContext context, required String topic}) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const FlashcardsPage()));
  Provider.of<FlashcardsNotifier>(context, listen: false)
      .setTopic(topic: topic);
}

runGuideBox({required BuildContext context, required bool isFirst}) {
  if (!isFirst) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('guidebox', true);
    });
  }

  Future.delayed(const Duration(milliseconds: 1200), () {
    showDialog(
        context: context,
        builder: (context) =>
            GuideBox(
              isFirst: isFirst,
            ));
  });
}

runQuickBox({required BuildContext context, required String text}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => QuickBox(text: text));
}
