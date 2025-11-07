import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Fade animation widget for smooth opacity transitions
class FadeAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final int delay;
  final double begin;
  final double end;

  const FadeAnimation({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.curve = Curves.easeInOut,
    this.delay = 0,
    this.begin = 0.0,
    this.end = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration + Duration(milliseconds: delay),
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Fade in animation
class FadeIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;

  const FadeIn({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      begin: 0.0,
      end: 1.0,
      duration: duration,
      delay: delay,
      child: child,
    );
  }
}

/// Fade out animation
class FadeOut extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;

  const FadeOut({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      begin: 1.0,
      end: 0.0,
      duration: duration,
      delay: delay,
      child: child,
    );
  }
}

/// Staggered fade in animation for lists
class StaggeredFadeIn extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final int staggerDelay;
  final Axis direction;

  const StaggeredFadeIn({
    Key? key,
    required this.children,
    this.duration = AppConstants.animationNormal,
    this.staggerDelay = 50,
    this.direction = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? Column(
            children: _buildStaggeredChildren(),
          )
        : Row(
            children: _buildStaggeredChildren(),
          );
  }

  List<Widget> _buildStaggeredChildren() {
    return List.generate(
      children.length,
      (index) => FadeIn(
        duration: duration,
        delay: index * staggerDelay,
        child: children[index],
      ),
    );
  }
}
