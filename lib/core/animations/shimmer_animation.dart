import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Shimmer loading animation widget
class ShimmerAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  State<ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.baseColor ??
        (isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight);
    final highlightColor = widget.highlightColor ??
        (isDark
            ? AppColors.shimmerHighlightDark
            : AppColors.shimmerHighlightLight);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Shimmer loading box
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight;

    return ShimmerAnimation(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Shimmer loading card
class ShimmerCard extends StatelessWidget {
  final double? height;
  final EdgeInsets? padding;

  const ShimmerCard({
    Key? key,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: double.infinity,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          ShimmerBox(
            width: 200,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          ShimmerBox(
            width: 150,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading list
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  const ShimmerList({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerCard(height: itemHeight),
        );
      },
    );
  }
}
