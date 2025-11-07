import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    textMultiplier = blockSizeHorizontal;
    imageSizeMultiplier = blockSizeVertical;
    heightMultiplier = blockSizeVertical;
    widthMultiplier = blockSizeHorizontal;
    orientation = _mediaQueryData.orientation;
  }

  // Device type detection
  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  static bool get isDesktop => screenWidth >= 1200;
  static bool get isLandscape => orientation == Orientation.landscape;
  static bool get isPortrait => orientation == Orientation.portrait;

  // Responsive padding/margin
  static double get paddingXSmall => blockSizeHorizontal * 2;
  static double get paddingSmall => blockSizeHorizontal * 4;
  static double get paddingMedium => blockSizeHorizontal * 6;
  static double get paddingLarge => blockSizeHorizontal * 8;
  static double get paddingXLarge => blockSizeHorizontal * 12;

  // Responsive font sizes
  static double get fontXSmall => textMultiplier * 10;
  static double get fontSmall => textMultiplier * 12;
  static double get fontMedium => textMultiplier * 14;
  static double get fontLarge => textMultiplier * 16;
  static double get fontXLarge => textMultiplier * 20;
  static double get fontXXLarge => textMultiplier * 24;
  static double get fontHuge => textMultiplier * 32;

  // Responsive icon sizes
  static double get iconSmall => blockSizeHorizontal * 5;
  static double get iconMedium => blockSizeHorizontal * 7;
  static double get iconLarge => blockSizeHorizontal * 10;
  static double get iconXLarge => blockSizeHorizontal * 15;

  // Responsive border radius
  static double get radiusSmall => blockSizeHorizontal * 2;
  static double get radiusMedium => blockSizeHorizontal * 3;
  static double get radiusLarge => blockSizeHorizontal * 4;

  // Responsive heights
  static double get heightSmall => blockSizeVertical * 5;
  static double get heightMedium => blockSizeVertical * 10;
  static double get heightLarge => blockSizeVertical * 20;

  // Responsive widths
  static double get widthSmall => blockSizeHorizontal * 20;
  static double get widthMedium => blockSizeHorizontal * 50;
  static double get widthLarge => blockSizeHorizontal * 80;

  // Grid columns based on screen size
  static int get gridColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    if (isLandscape) return 2;
    return 1;
  }

  // Safe padding for notches
  static EdgeInsets get safePadding => EdgeInsets.only(
    top: _mediaQueryData.padding.top,
    bottom: _mediaQueryData.padding.bottom,
    left: _mediaQueryData.padding.left,
    right: _mediaQueryData.padding.right,
  );

  // Responsive spacing
  static SizedBox get spacingXSmall => SizedBox(height: blockSizeVertical * 1);
  static SizedBox get spacingSmall => SizedBox(height: blockSizeVertical * 2);
  static SizedBox get spacingMedium => SizedBox(height: blockSizeVertical * 3);
  static SizedBox get spacingLarge => SizedBox(height: blockSizeVertical * 5);
  static SizedBox get spacingXLarge => SizedBox(height: blockSizeVertical * 8);

  static SizedBox horizontalSpacingSmall() => SizedBox(width: blockSizeHorizontal * 2);
  static SizedBox horizontalSpacingMedium() => SizedBox(width: blockSizeHorizontal * 4);
  static SizedBox horizontalSpacingLarge() => SizedBox(width: blockSizeHorizontal * 6);
}
