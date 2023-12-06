import 'dart:math';

import 'package:flutter/material.dart';
import 'package:questure/components/question.dart';
import 'package:questure/components/results.dart';
import 'package:questure/configs/constants.dart';
import 'package:questure/enums/slide_direction.dart';

class FlashcardsNotifier extends ChangeNotifier {
  String topic = ""; // Add this line to declare the topic variable

  List<Question> selectedQuestions = []; // Add this line for selectedQuestions

  List<Question> incorrectCards = []; // Add this line for incorrectCards

  int roundTally = 0,
      cardTally = 0,
      correctTally = 0,
      incorrectTally = 0,
      correctPercentage = 0;

  double percentComplete = 0.0;

  calculateCorrectPercentage() {
    final percentage = cardTally != 0 ? correctTally / cardTally : 0;
    correctPercentage = (percentage * 100).round();
  }

  calculateCompletedPercent() {
    percentComplete = (correctTally + incorrectTally) / cardTally;
    notifyListeners();
  }

  resetProgressBar() {
    percentComplete = 0.0;
    notifyListeners();
  }

  bool isFirstRound = true,
      isRoundCompleted = false,
      isSessionCompleted = false;

  reset() {
    resetQuestion();
    resetAnswer();
    incorrectCards.clear();
    isFirstRound = true;
    isRoundCompleted = false;
    isSessionCompleted = false;
    roundTally = 0;
  }

  setTopic({required String topic}) {
    this.topic = topic;
    notifyListeners();
  }

  startRound() {
    roundTally++;
    cardTally = selectedQuestions.length;
    correctTally = 0;
    incorrectTally = 0;
    resetProgressBar();
  }

  updateCardOutcome({required Question question, required bool isCorrect}) {
    if (!isCorrect) {
      incorrectCards.add(question);
      incorrectTally++;
    } else {
      correctTally++;
    }
    calculateCompletedPercent();
  }

  /// Card animation code

  bool ignoreTouches = true;

  setIgnoreTouch({required bool ignore}) {
    ignoreTouches = ignore;
  }

  SlideDirection swipedDirection = SlideDirection.none;

  bool slideQuestion = false,
      flipQuestion = false,
      flipAnswer = false,
      swipeAnswer = false;

  bool resetSlideQuestion = false,
      resetFlipQuestion = false,
      resetFlipAnswer = false,
      resetSwipeAnswer = false;

  runSlideQuestion() {
    resetSlideQuestion = false;
    slideQuestion = true;
    notifyListeners();
  }

  runFlipQuestion() {
    resetFlipQuestion = false;
    flipQuestion = true;
    notifyListeners();
  }

  resetQuestion() {
    resetSlideQuestion = true;
    resetFlipQuestion = true;
    slideQuestion = false;
    flipQuestion = false;
  }

  runFlipAnswer() {
    resetFlipAnswer = false;
    flipAnswer = true;
    notifyListeners();
  }

  runSwipeAnswer({required SlideDirection direction}) {
    updateCardOutcome(
        question: selectedQuestions[roundTally - 1],
        isCorrect: direction == SlideDirection.leftAway);
    swipedDirection = direction;
    resetSwipeAnswer = false;
    swipeAnswer = true;
    notifyListeners();
  }

  resetAnswer() {
    resetFlipAnswer = true;
    resetSwipeAnswer = true;
    flipAnswer = false;
    swipeAnswer = false;
  }

  void generateCurrentWord({required BuildContext context}) {}

  void generateAllQuestions() {}

  void generateCurrentQuestion({required BuildContext context}) {}
}
