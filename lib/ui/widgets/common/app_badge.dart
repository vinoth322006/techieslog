import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

/// Standardized badge widget for status, priority, and categories
class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? fontSize;
  final EdgeInsets? padding;
  final double? borderRadius;

  const AppBadge({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing12,
            vertical: AppConstants.spacing4,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppConstants.radiusSmall,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppConstants.iconSmall,
              color: textColor ?? Theme.of(context).primaryColor,
            ),
            const SizedBox(width: AppConstants.spacing4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? AppConstants.fontSmall,
              fontWeight: FontWeight.w600,
              color: textColor ?? Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Status badge with predefined colors
class StatusBadge extends StatelessWidget {
  final int status;
  final bool showIcon;

  const StatusBadge({
    Key? key,
    required this.status,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getStatusColor(status);
    final statusName = AppColors.getStatusName(status);
    
    IconData? icon;
    if (showIcon) {
      switch (status) {
        case 0:
          icon = Icons.radio_button_unchecked;
          break;
        case 1:
          icon = Icons.pending_outlined;
          break;
        case 2:
          icon = Icons.check_circle_outline;
          break;
        case 3:
          icon = Icons.pause_circle_outline;
          break;
        case 4:
          icon = Icons.cancel_outlined;
          break;
      }
    }

    return AppBadge(
      text: statusName,
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      icon: icon,
    );
  }
}

/// Priority badge with predefined colors
class PriorityBadge extends StatelessWidget {
  final int priority;
  final bool showIcon;

  const PriorityBadge({
    Key? key,
    required this.priority,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getPriorityColor(priority);
    final priorityName = AppColors.getPriorityName(priority);
    
    IconData? icon;
    if (showIcon) {
      switch (priority) {
        case 1:
          icon = Icons.arrow_downward;
          break;
        case 2:
          icon = Icons.remove;
          break;
        case 3:
          icon = Icons.drag_handle;
          break;
        case 4:
          icon = Icons.arrow_upward;
          break;
        case 5:
          icon = Icons.priority_high;
          break;
      }
    }

    return AppBadge(
      text: priorityName,
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      icon: icon,
    );
  }
}

/// Category badge with predefined colors
class CategoryBadge extends StatelessWidget {
  final String category;
  final bool showIcon;

  const CategoryBadge({
    Key? key,
    required this.category,
    this.showIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getCategoryColor(category);

    return AppBadge(
      text: category,
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      icon: showIcon ? Icons.label_outline : null,
    );
  }
}

/// Small badge variant (for counts, notifications)
class AppBadgeSmall extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const AppBadgeSmall({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing8,
        vertical: AppConstants.spacing4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppConstants.fontXSmall,
          fontWeight: FontWeight.w700,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}

/// Dot badge (notification indicator)
class AppBadgeDot extends StatelessWidget {
  final Color? color;
  final double? size;

  const AppBadgeDot({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? AppConstants.spacing8,
      height: size ?? AppConstants.spacing8,
      decoration: BoxDecoration(
        color: color ?? AppColors.error,
        shape: BoxShape.circle,
      ),
    );
  }
}
