import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Standardized card widget with consistent styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showShadow;

  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.gradient,
    this.onTap,
    this.onLongPress,
    this.showShadow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget cardContent = Container(
      padding: padding ?? AppConstants.cardPaddingMedium,
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null
            ? (color ?? Theme.of(context).cardTheme.color)
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppConstants.radiusLarge,
        ),
        border: border,
        boxShadow: showShadow
            ? (boxShadow ??
                [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ])
            : null,
      ),
      child: child,
    );

    if (onTap != null || onLongPress != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.radiusLarge,
          ),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// Small card variant
class AppCardSmall extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;

  const AppCardSmall({
    Key? key,
    required this.child,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppConstants.cardPaddingSmall,
      borderRadius: AppConstants.radiusMedium,
      onTap: onTap,
      color: color,
      child: child,
    );
  }
}

/// Large card variant
class AppCardLarge extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final bool showShadow;

  const AppCardLarge({
    Key? key,
    required this.child,
    this.onTap,
    this.color,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppConstants.cardPaddingLarge,
      borderRadius: AppConstants.radiusXLarge,
      onTap: onTap,
      color: color,
      showShadow: showShadow,
      child: child,
    );
  }
}

/// Gradient card variant
class AppCardGradient extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const AppCardGradient({
    Key? key,
    required this.child,
    required this.gradient,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradient: gradient,
      onTap: onTap,
      padding: padding,
      showShadow: true,
      child: child,
    );
  }
}

/// Outlined card variant
class AppCardOutlined extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const AppCardOutlined({
    Key? key,
    required this.child,
    this.borderColor,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppCard(
      border: Border.all(
        color: borderColor ??
            (isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        width: 1,
      ),
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }
}
