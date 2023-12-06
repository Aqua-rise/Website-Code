import 'dart:math';

import 'package:flutter/material.dart';
import 'package:questure/configs/constants.dart';
import 'package:provider/provider.dart';
import '../../animations/flip_animation.dart';
import '../../animations/slide_animation.dart';
import '../../enums/slide_direction.dart';
import '../../notifiers/flashcard_notifier.dart';
import 'card_display.dart';

class Answer extends StatelessWidget {
  const Answer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 100) {
            notifier.runSwipeAnswer(direction: SlideDirection.leftAway);
            notifier.runSlideQuestion();
            notifier.setIgnoreTouch(ignore: true);
            notifier.generateCurrentWord(context: context);
          }
          if (details.primaryVelocity! < -100) {
            notifier.runSwipeAnswer(direction: SlideDirection.rightAway);
            notifier.runSlideQuestion();
            notifier.setIgnoreTouch(ignore: true);
            notifier.generateCurrentWord(context: context);
          }
        },
        child: FlipAnimation(
          animate: notifier.flipAnswer,
          reset: notifier.resetFlipAnswer,
          flipFromHalfWay: true,
          animationCompleted: () {
            notifier.setIgnoreTouch(ignore: false);
          },
          child: SlideAnimation(
            animationCompleted: () {
              notifier.resetAnswer();
            },
            reset: notifier.resetSwipeAnswer,
            animate: notifier.swipeAnswer,
            direction: notifier.swipedDirection,
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
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: const CardDisplay(isQuestion: false)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
