import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../animations/flip_animation.dart';
import '../../animations/slide_animation.dart';
import 'package:questure/configs/constants.dart';
import '../../enums/slide_direction.dart';
import '../../notifiers/flashcard_notifier.dart';
import '../../util/methods.dart';
import 'card_display.dart';

class Question extends StatelessWidget {
  const Question({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        onDoubleTap: () {
          notifier.runFlipQuestion();
          notifier.setIgnoreTouch(ignore: true);
          SharedPreferences.getInstance().then((prefs) {
            if (prefs.getBool('guidebox') == null) {
              runGuideBox(context: context, isFirst: false);
            }
          });
        },
        child: FlipAnimation(
          animate: notifier.flipQuestion,
          reset: notifier.resetFlipQuestion,
          flipFromHalfWay: false,
          animationCompleted: () {
            notifier.resetQuestion();
            var runFlipAnswer = notifier.runFlipAnswer();
          },
          child: SlideAnimation(
            animationDuration: 1000,
            animationDelay: 200,
            animationCompleted: () {
              notifier.setIgnoreTouch(ignore: false);
            },
            reset: notifier.resetSlideQuestion,
            animate: notifier.slideQuestion && !notifier.isRoundCompleted,
            direction: SlideDirection.upIn,
            child: Center(
              child: Container(
                width: size.width * 0.90,
                height: size.height * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kCircularBorderRadius),
                  border: Border.all(
                    color: Colors.white,
                    width: kCardBorderWidth,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: const CardDisplay(isQuestion: true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
