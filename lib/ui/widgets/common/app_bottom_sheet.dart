import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Standardized bottom sheet widget
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final double? height;
  final bool showHandle;
  final EdgeInsets? padding;

  const AppBottomSheet({
    Key? key,
    this.title,
    required this.child,
    this.height,
    this.showHandle = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            const SizedBox(height: AppConstants.spacing12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              ),
            ),
            const SizedBox(height: AppConstants.spacing12),
          ],
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing20,
                vertical: AppConstants.spacing12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: AppConstants.fontXXLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE5E7EB),
            ),
          ],
          Flexible(
            child: SingleChildScrollView(
              padding: padding ??
                  const EdgeInsets.all(AppConstants.spacing20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  /// Show bottom sheet helper
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    double? height,
    bool showHandle = true,
    EdgeInsets? padding,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        title: title,
        height: height,
        showHandle: showHandle,
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Bottom sheet with action buttons
class AppBottomSheetActions extends StatelessWidget {
  final String title;
  final List<AppBottomSheetAction> actions;

  const AppBottomSheetActions({
    Key? key,
    required this.title,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: title,
      showHandle: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: actions.map((action) {
          return ListTile(
            leading: action.icon != null
                ? Icon(
                    action.icon,
                    color: action.iconColor,
                  )
                : null,
            title: Text(
              action.title,
              style: TextStyle(
                color: action.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: action.subtitle != null
                ? Text(action.subtitle!)
                : null,
            onTap: () {
              Navigator.of(context).pop();
              action.onTap?.call();
            },
          );
        }).toList(),
      ),
    );
  }

  /// Show action bottom sheet
  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<AppBottomSheetAction> actions,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheetActions(
        title: title,
        actions: actions,
      ),
    );
  }
}

/// Bottom sheet action item
class AppBottomSheetAction {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const AppBottomSheetAction({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.textColor,
    this.onTap,
  });
}

/// Form bottom sheet
class AppBottomSheetForm extends StatelessWidget {
  final String title;
  final Widget form;
  final String submitText;
  final VoidCallback? onSubmit;
  final bool isSubmitting;

  const AppBottomSheetForm({
    Key? key,
    required this.title,
    required this.form,
    this.submitText = 'Submit',
    this.onSubmit,
    this.isSubmitting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: title,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          form,
          const SizedBox(height: AppConstants.spacing24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacing16,
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: AppConstants.iconMedium,
                      height: AppConstants.iconMedium,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(submitText),
            ),
          ),
        ],
      ),
    );
  }
}
