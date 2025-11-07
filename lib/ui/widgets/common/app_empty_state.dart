import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Standardized empty state widget
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;

  const AppEmptyState({
    Key? key,
    required this.icon,
    required this.title,
    this.message,
    this.actionText,
    this.onAction,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: AppConstants.screenPaddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spacing24),
              decoration: BoxDecoration(
                color: (iconColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppConstants.iconXXXLarge * 1.5,
                color: iconColor ?? Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: AppConstants.spacing24),
            Text(
              title,
              style: TextStyle(
                fontSize: AppConstants.fontXXLarge,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppConstants.spacing12),
              Text(
                message!,
                style: TextStyle(
                  fontSize: AppConstants.fontMedium,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppConstants.spacing32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacing24,
                    vertical: AppConstants.spacing16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for no data
class AppEmptyStateNoData extends StatelessWidget {
  final String title;
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyStateNoData({
    Key? key,
    this.title = 'No Data',
    this.message = 'There is no data to display yet.',
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.inbox_rounded,
      title: title,
      message: message,
      actionText: actionText,
      onAction: onAction,
    );
  }
}

/// Empty state for search results
class AppEmptyStateSearch extends StatelessWidget {
  final String searchQuery;

  const AppEmptyStateSearch({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.search_off_rounded,
      title: 'No Results Found',
      message: 'We couldn\'t find anything matching "$searchQuery"',
    );
  }
}

/// Empty state for errors
class AppEmptyStateError extends StatelessWidget {
  final String title;
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyStateError({
    Key? key,
    this.title = 'Something Went Wrong',
    this.message = 'An error occurred. Please try again.',
    this.actionText = 'Retry',
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.error_outline_rounded,
      title: title,
      message: message,
      actionText: actionText,
      onAction: onAction,
      iconColor: Colors.red,
    );
  }
}
