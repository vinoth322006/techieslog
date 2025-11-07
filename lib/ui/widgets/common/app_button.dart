import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Standardized button widget with variants
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isOutlined;
  final bool isText;
  final EdgeInsets? padding;
  final double? borderRadius;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.isOutlined = false,
    this.isText = false,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isText) {
      return _buildTextButton(context);
    }
    
    if (isOutlined) {
      return _buildOutlinedButton(context);
    }
    
    return _buildElevatedButton(context);
  }

  Widget _buildElevatedButton(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? AppConstants.buttonHeightMedium,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing24,
                vertical: AppConstants.spacing12,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppConstants.radiusMedium,
            ),
          ),
        ),
        child: _buildButtonChild(),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? AppConstants.buttonHeightMedium,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? backgroundColor,
          side: BorderSide(
            color: backgroundColor ?? Theme.of(context).primaryColor,
          ),
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing24,
                vertical: AppConstants.spacing12,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppConstants.radiusMedium,
            ),
          ),
        ),
        child: _buildButtonChild(),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? backgroundColor,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: AppConstants.spacing16,
              vertical: AppConstants.spacing8,
            ),
      ),
      child: _buildButtonChild(),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return const SizedBox(
        width: AppConstants.iconMedium,
        height: AppConstants.iconMedium,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppConstants.iconMedium),
          const SizedBox(width: AppConstants.spacing8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

/// Primary button variant
class AppButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const AppButtonPrimary({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }
}

/// Secondary button variant
class AppButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const AppButtonSecondary({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isOutlined: true,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

/// Small button variant
class AppButtonSmall extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;

  const AppButtonSmall({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: backgroundColor,
      height: AppConstants.buttonHeightSmall,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing8,
      ),
    );
  }
}

/// Icon button with background
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  const AppIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? AppConstants.buttonHeightMedium;
    
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: iconColor ?? Theme.of(context).primaryColor,
        iconSize: AppConstants.iconMedium,
      ),
    );
  }
}
