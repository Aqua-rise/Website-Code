import 'dart:math';

import 'package:flutter/material.dart';

class FlipAnimation extends StatefulWidget {
  const FlipAnimation(
      {required this.child,
      required this.animate,
      required this.reset,
      required this.flipFromHalfWay,
      required this.animationCompleted,
      Key? key})
      : super(key: key);

  final Widget child;
  final bool animate;
  final bool reset;
  final bool flipFromHalfWay;
  final VoidCallback animationCompleted;

  @override
  State<FlipAnimation> createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..addListener(() {
        if (_animationController.isCompleted) {
          widget.animationCompleted.call();
        }
      });
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  didUpdateWidget(covariant oldWidget) {
    if (widget.reset) {
      _animationController.reset();
    }

    if (widget.animate) {
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double rotationAdjustment = 0;
    if (widget.flipFromHalfWay) {
      rotationAdjustment = pi / 2;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY((_animationController.value * pi) / 2)
          ..rotateY(rotationAdjustment),
        child: widget.child,
      ),
    );
  }
}
