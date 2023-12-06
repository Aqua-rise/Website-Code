import 'dart:math';

import 'package:flutter/material.dart';
import 'package:questure/components/results.dart';
import 'package:questure/configs/constants.dart';
import 'package:questure/enums/slide_direction.dart';

class FlashcardsNotifier extends ChangeNotifier {
  int roundTally = 0,
      cardTally = 0,
      correctTally = 0,
      incorrectTally = 0,
      correctPercentage = 0;

  calculateCorrectPercentage() {
    final percentage = correctTally / cardTally;
    correctPercentage = (percentage * 100).round();
  }

  double percentComplete = 0.0;

  calculateCompletedPercent() {
    percentComplete = (correctTally + incorrectTally) / cardTally;
    notifyListeners();
  }

  resetProgressBar() {
    percentComplete = 0.0;
    notifyListeners();
  }

//Implementation for incorrect cards would go here

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
        word: word2, isCorrect: direction == SlideDirection.leftAway);
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
