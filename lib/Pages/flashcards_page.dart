import 'package:flutter/material.dart';
import 'package:questure/components/progress_bar.dart';
import 'package:questure/configs/constants.dart';
import 'package:questure/notifiers/flashcard_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:questure/app/custom_appbar.dart';
import 'package:questure/components/question.dart';
import 'package:questure/components/answer.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final flashcardsNotifier =
          Provider.of<FlashcardsNotifier>(context, listen: false);
      flashcardsNotifier.runSlideQuestion();
      flashcardsNotifier.generateAllQuestions();
      flashcardsNotifier.generateCurrentQuestion(context: context);
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.getBool('guidebox') == null) {
          runGuideBox(context: context, isFirst: true);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kAppBarHeight),
            child: CustomAppBar()),
        body: IgnorePointer(
          ignoring: notifier.ignoreTouches,
          child: Stack(
            children: const [
              Align(alignment: Alignment.bottomCenter, child: ProgressBar()),
              Answer(),
              Question(),
            ],
          ),
        ),
      ),
    );
  }
}
