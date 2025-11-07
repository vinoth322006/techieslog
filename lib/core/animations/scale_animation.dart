import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Scale animation widget for smooth size transitions
class ScaleAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final int delay;
  final double begin;
  final double end;
  final Alignment alignment;

  const ScaleAnimation({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.curve = Curves.easeOutBack,
    this.delay = 0,
    this.begin = 0.8,
    this.end = 1.0,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration + Duration(milliseconds: delay),
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          alignment: alignment,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Scale in animation
class ScaleIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;
  final Alignment alignment;

  const ScaleIn({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleAnimation(
      begin: 0.0,
      end: 1.0,
      duration: duration,
      delay: delay,
      alignment: alignment,
      child: child,
    );
  }
}

/// Scale out animation
class ScaleOut extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;
  final Alignment alignment;

  const ScaleOut({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleAnimation(
      begin: 1.0,
      end: 0.0,
      duration: duration,
      delay: delay,
      alignment: alignment,
      child: child,
    );
  }
}

/// Pop animation (scale with bounce)
class PopAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final int delay;

  const PopAnimation({
    Key? key,
    required this.child,
    this.duration = AppConstants.animationNormal,
    this.delay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleAnimation(
      begin: 0.8,
      end: 1.0,
      duration: duration,
      delay: delay,
      curve: Curves.elasticOut,
      child: child,
    );
  }
}

/// Pulse animation (continuous scale)
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulseAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  }) : super(key: key);

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
