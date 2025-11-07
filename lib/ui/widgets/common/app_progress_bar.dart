import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Standardized progress bar widget
class AppProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color? backgroundColor;
  final Color? progressColor;
  final double? height;
  final double? borderRadius;
  final bool showPercentage;
  final String? label;

  const AppProgressBar({
    Key? key,
    required this.value,
    this.backgroundColor,
    this.progressColor,
    this.height,
    this.borderRadius,
    this.showPercentage = false,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = (value * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    fontWeight: FontWeight.w600,
                    color: progressColor ?? Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.radiusFull,
          ),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            backgroundColor: backgroundColor ??
                (isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE5E7EB)),
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? Theme.of(context).primaryColor,
            ),
            minHeight: height ?? AppConstants.progressBarHeight,
          ),
        ),
      ],
    );
  }
}

/// Circular progress indicator
class AppCircularProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color? backgroundColor;
  final Color? progressColor;
  final double? size;
  final double? strokeWidth;
  final bool showPercentage;
  final Widget? child;

  const AppCircularProgress({
    Key? key,
    required this.value,
    this.backgroundColor,
    this.progressColor,
    this.size,
    this.strokeWidth,
    this.showPercentage = true,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = (value * 100).toInt();
    final circleSize = size ?? 80.0;

    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: circleSize,
            height: circleSize,
            child: CircularProgressIndicator(
              value: value.clamp(0.0, 1.0),
              backgroundColor: backgroundColor ??
                  (isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE5E7EB)),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? Theme.of(context).primaryColor,
              ),
              strokeWidth: strokeWidth ?? 8.0,
            ),
          ),
          if (showPercentage && child == null)
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: circleSize * 0.2,
                fontWeight: FontWeight.bold,
                color: progressColor ?? Theme.of(context).primaryColor,
              ),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// Progress bar with gradient
class AppProgressBarGradient extends StatelessWidget {
  final double value;
  final Gradient gradient;
  final Color? backgroundColor;
  final double? height;
  final bool showPercentage;
  final String? label;

  const AppProgressBarGradient({
    Key? key,
    required this.value,
    required this.gradient,
    this.backgroundColor,
    this.height,
    this.showPercentage = false,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = (value * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing8),
        ],
        Container(
          height: height ?? AppConstants.progressBarHeight,
          decoration: BoxDecoration(
            color: backgroundColor ??
                (isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Segmented progress bar (for multi-step processes)
class AppProgressBarSegmented extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? height;

  const AppProgressBarSegmented({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.inactiveColor,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: List.generate(
        totalSteps,
        (index) => Expanded(
          child: Container(
            height: height ?? AppConstants.progressBarHeight,
            margin: EdgeInsets.only(
              right: index < totalSteps - 1 ? AppConstants.spacing4 : 0,
            ),
            decoration: BoxDecoration(
              color: index < currentStep
                  ? (activeColor ?? Theme.of(context).primaryColor)
                  : (inactiveColor ??
                      (isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE5E7EB))),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
          ),
        ),
      ),
    );
  }
}
