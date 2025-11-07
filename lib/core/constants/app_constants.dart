import 'package:flutter/material.dart';

/// App-wide constants for consistent spacing, sizing, and timing
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  static const double spacing4 = 4.0;
  
  /// Small spacing - 8px
  static const double spacing8 = 8.0;
  
  /// Medium-small spacing - 12px
  static const double spacing12 = 12.0;
  
  /// Medium spacing - 16px (most common)
  static const double spacing16 = 16.0;
  
  /// Medium-large spacing - 20px
  static const double spacing20 = 20.0;
  
  /// Large spacing - 24px
  static const double spacing24 = 24.0;
  
  /// Extra large spacing - 32px
  static const double spacing32 = 32.0;
  
  /// XXL spacing - 40px
  static const double spacing40 = 40.0;
  
  /// XXXL spacing - 48px
  static const double spacing48 = 48.0;

  // ==================== BORDER RADIUS ====================
  /// Extra small radius - 4px
  static const double radiusXSmall = 4.0;
  
  /// Small radius - 8px
  static const double radiusSmall = 8.0;
  
  /// Medium radius - 12px
  static const double radiusMedium = 12.0;
  
  /// Large radius - 16px
  static const double radiusLarge = 16.0;
  
  /// Extra large radius - 20px
  static const double radiusXLarge = 20.0;
  
  /// XXL radius - 24px
  static const double radiusXXLarge = 24.0;
  
  /// Full circle radius
  static const double radiusFull = 999.0;

  // ==================== ICON SIZES ====================
  /// Extra small icon - 12px
  static const double iconXSmall = 12.0;
  
  /// Small icon - 16px
  static const double iconSmall = 16.0;
  
  /// Medium icon - 20px
  static const double iconMedium = 20.0;
  
  /// Large icon - 24px
  static const double iconLarge = 24.0;
  
  /// Extra large icon - 32px
  static const double iconXLarge = 32.0;
  
  /// XXL icon - 40px
  static const double iconXXLarge = 40.0;
  
  /// XXXL icon - 48px
  static const double iconXXXLarge = 48.0;

  // ==================== FONT SIZES ====================
  /// Extra small font - 10px
  static const double fontXSmall = 10.0;
  
  /// Small font - 12px
  static const double fontSmall = 12.0;
  
  /// Medium font - 14px
  static const double fontMedium = 14.0;
  
  /// Large font - 16px
  static const double fontLarge = 16.0;
  
  /// Extra large font - 18px
  static const double fontXLarge = 18.0;
  
  /// XXL font - 20px
  static const double fontXXLarge = 20.0;
  
  /// XXXL font - 24px
  static const double fontXXXLarge = 24.0;
  
  /// Display font - 28px
  static const double fontDisplay = 28.0;
  
  /// Large display font - 32px
  static const double fontDisplayLarge = 32.0;

  // ==================== ELEVATION ====================
  /// No elevation
  static const double elevationNone = 0.0;
  
  /// Small elevation - 2px
  static const double elevationSmall = 2.0;
  
  /// Medium elevation - 4px
  static const double elevationMedium = 4.0;
  
  /// Large elevation - 8px
  static const double elevationLarge = 8.0;
  
  /// Extra large elevation - 12px
  static const double elevationXLarge = 12.0;

  // ==================== ANIMATION DURATIONS ====================
  /// Extra fast animation - 100ms
  static const Duration animationXFast = Duration(milliseconds: 100);
  
  /// Fast animation - 150ms
  static const Duration animationFast = Duration(milliseconds: 150);
  
  /// Normal animation - 300ms
  static const Duration animationNormal = Duration(milliseconds: 300);
  
  /// Slow animation - 500ms
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  /// Extra slow animation - 700ms
  static const Duration animationXSlow = Duration(milliseconds: 700);

  // ==================== OPACITY ====================
  /// Disabled opacity
  static const double opacityDisabled = 0.38;
  
  /// Medium opacity
  static const double opacityMedium = 0.6;
  
  /// Light opacity
  static const double opacityLight = 0.8;
  
  /// Hover opacity
  static const double opacityHover = 0.04;
  
  /// Focus opacity
  static const double opacityFocus = 0.12;
  
  /// Selected opacity
  static const double opacitySelected = 0.16;

  // ==================== BUTTON SIZES ====================
  /// Small button height
  static const double buttonHeightSmall = 32.0;
  
  /// Medium button height
  static const double buttonHeightMedium = 40.0;
  
  /// Large button height
  static const double buttonHeightLarge = 48.0;
  
  /// Extra large button height
  static const double buttonHeightXLarge = 56.0;

  // ==================== INPUT SIZES ====================
  /// Small input height
  static const double inputHeightSmall = 36.0;
  
  /// Medium input height
  static const double inputHeightMedium = 44.0;
  
  /// Large input height
  static const double inputHeightLarge = 52.0;

  // ==================== CARD SIZES ====================
  /// Small card padding
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(12.0);
  
  /// Medium card padding
  static const EdgeInsets cardPaddingMedium = EdgeInsets.all(16.0);
  
  /// Large card padding
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(20.0);

  // ==================== SCREEN PADDING ====================
  /// Small screen padding
  static const EdgeInsets screenPaddingSmall = EdgeInsets.all(12.0);
  
  /// Medium screen padding
  static const EdgeInsets screenPaddingMedium = EdgeInsets.all(16.0);
  
  /// Large screen padding
  static const EdgeInsets screenPaddingLarge = EdgeInsets.all(20.0);
  
  /// Horizontal screen padding
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
  
  /// Vertical screen padding
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: 16.0);

  // ==================== ASPECT RATIOS ====================
  /// Square aspect ratio
  static const double aspectRatioSquare = 1.0;
  
  /// Wide aspect ratio (16:9)
  static const double aspectRatioWide = 16 / 9;
  
  /// Card aspect ratio (3:2)
  static const double aspectRatioCard = 3 / 2;
  
  /// Portrait aspect ratio (3:4)
  static const double aspectRatioPortrait = 3 / 4;

  // ==================== MAX WIDTHS ====================
  /// Max width for mobile
  static const double maxWidthMobile = 600.0;
  
  /// Max width for tablet
  static const double maxWidthTablet = 900.0;
  
  /// Max width for desktop
  static const double maxWidthDesktop = 1200.0;
  
  /// Max width for content
  static const double maxWidthContent = 800.0;

  // ==================== DIVIDER ====================
  /// Divider thickness
  static const double dividerThickness = 1.0;
  
  /// Divider indent
  static const double dividerIndent = 16.0;

  // ==================== PROGRESS ====================
  /// Progress bar height
  static const double progressBarHeight = 8.0;
  
  /// Progress bar height small
  static const double progressBarHeightSmall = 4.0;
  
  /// Progress bar height large
  static const double progressBarHeightLarge = 12.0;

  // ==================== BADGE ====================
  /// Badge size small
  static const double badgeSizeSmall = 16.0;
  
  /// Badge size medium
  static const double badgeSizeMedium = 20.0;
  
  /// Badge size large
  static const double badgeSizeLarge = 24.0;

  // ==================== AVATAR ====================
  /// Avatar size small
  static const double avatarSizeSmall = 32.0;
  
  /// Avatar size medium
  static const double avatarSizeMedium = 40.0;
  
  /// Avatar size large
  static const double avatarSizeLarge = 48.0;
  
  /// Avatar size extra large
  static const double avatarSizeXLarge = 64.0;

  // ==================== APP BAR ====================
  /// App bar height
  static const double appBarHeight = 56.0;
  
  /// App bar height large
  static const double appBarHeightLarge = 64.0;

  // ==================== BOTTOM NAV ====================
  /// Bottom navigation bar height
  static const double bottomNavHeight = 60.0;
  
  /// Bottom navigation bar height large
  static const double bottomNavHeightLarge = 72.0;

  // ==================== FAB ====================
  /// FAB size small
  static const double fabSizeSmall = 40.0;
  
  /// FAB size medium
  static const double fabSizeMedium = 56.0;
  
  /// FAB size large
  static const double fabSizeLarge = 64.0;

  // ==================== LIST TILE ====================
  /// List tile height
  static const double listTileHeight = 56.0;
  
  /// List tile height dense
  static const double listTileHeightDense = 48.0;
  
  /// List tile height large
  static const double listTileHeightLarge = 72.0;
}
