import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Standardized dialog widget
class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final bool dismissible;

  const AppDialog({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.dismissible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => dismissible,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing8),
                decoration: BoxDecoration(
                  color: (iconColor ?? Theme.of(context).primaryColor)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).primaryColor,
                  size: AppConstants.iconLarge,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: AppConstants.fontXXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: content,
        actions: actions,
        actionsPadding: const EdgeInsets.all(AppConstants.spacing16),
      ),
    );
  }

  /// Show dialog helper
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    IconData? icon,
    Color? iconColor,
    bool dismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
        dismissible: dismissible,
      ),
    );
  }
}

/// Confirmation dialog
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;

  const AppConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      icon: icon ?? Icons.help_outline_rounded,
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Show confirmation dialog
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        icon: icon,
      ),
    );
    return result ?? false;
  }
}

/// Delete confirmation dialog
class AppDeleteDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback? onDelete;

  const AppDeleteDialog({
    Key? key,
    required this.itemName,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      title: 'Delete $itemName?',
      message: 'This action cannot be undone. Are you sure you want to delete this $itemName?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmColor: Colors.red,
      icon: Icons.delete_outline_rounded,
      onConfirm: onDelete,
    );
  }

  /// Show delete confirmation
  static Future<bool> show({
    required BuildContext context,
    required String itemName,
    VoidCallback? onDelete,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AppDeleteDialog(
        itemName: itemName,
        onDelete: onDelete,
      ),
    );
    return result ?? false;
  }
}

/// Info dialog
class AppInfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;

  const AppInfoDialog({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      icon: icon ?? Icons.info_outline_rounded,
      iconColor: iconColor,
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  /// Show info dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AppInfoDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}
