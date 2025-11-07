import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/animations/shimmer_animation.dart';

/// Standardized loading widget
class AppLoading extends StatelessWidget {
  final String? message;
  final double? size;

  const AppLoading({
    Key? key,
    this.message,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? AppConstants.iconXXXLarge,
            height: size ?? AppConstants.iconXXXLarge,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppConstants.spacing16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: AppConstants.fontMedium,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small loading indicator
class AppLoadingSmall extends StatelessWidget {
  final Color? color;

  const AppLoadingSmall({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.iconMedium,
      height: AppConstants.iconMedium,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

/// Loading overlay
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const AppLoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: AppLoading(message: message),
          ),
      ],
    );
  }
}

/// Shimmer loading card
class AppLoadingCard extends StatelessWidget {
  final double? height;

  const AppLoadingCard({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerCard(height: height);
  }
}

/// Shimmer loading list
class AppLoadingList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const AppLoadingList({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerList(
      itemCount: itemCount,
      itemHeight: itemHeight,
    );
  }
}

/// Loading button state
class AppLoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const AppLoadingButton({
    Key? key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacing24,
          vertical: AppConstants.spacing16,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: AppConstants.iconMedium,
              height: AppConstants.iconMedium,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(text),
    );
  }
}
