import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Slide animation widget for smooth transitions
class SlideAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Offset begin;
  final Offset end;
  final Curve curve;
  final int delay;

  const SlideAnimation({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.begin = const Offset(0, 0.3),
    this.end = Offset.zero,
    this.curve = Curves.easeOutCubic,
    this.delay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + Duration(milliseconds: delay),
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset.lerp(begin, end, value)!,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Slide from bottom animation
class SlideFromBottom extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;

  const SlideFromBottom({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
      duration: duration,
      delay: delay,
      child: child,
    );
  }
}

/// Slide from top animation
class SlideFromTop extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;

  const SlideFromTop({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
      duration: duration,
      delay: delay,
      child: child,
    );
  }
}

/// Slide from left animation
class SlideFromLeft extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;

  const SlideFromLeft({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
      duration: duration,
      delay: delay,
      child: child,
    );
  }
}

/// Slide from right animation
class SlideFromRight extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;

  const SlideFromRight({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
      duration: duration,
      delay: delay,
      child: child,
    );
  }
}
