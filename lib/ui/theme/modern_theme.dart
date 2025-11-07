import 'package:flutter/material.dart';

class ModernTheme {
  // Modern Color Palette
  static const primaryColor = Color(0xFF6366F1); // Indigo
  static const secondaryColor = Color(0xFF8B5CF6); // Purple
  static const accentColor = Color(0xFF06B6D4); // Cyan
  static const successColor = Color(0xFF10B981); // Green
  static const warningColor = Color(0xFFF59E0B); // Amber
  static const errorColor = Color(0xFFEF4444); // Red
  
  // Neutral Colors
  static const backgroundColor = Color(0xFFF9FAFB);
  static const surfaceColor = Colors.white;
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const borderColor = Color(0xFFE5E7EB);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  // Text Styles
  static const displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const displayMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const bodyLarge = TextStyle(
    fontSize: 16,
    color: textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // Dark Theme - Improved with better contrast and clarity
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: const Color(0xFF1E293B),
        background: const Color(0xFF0F172A),
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFFE2E8F0),
        onBackground: const Color(0xFFE2E8F0),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      
      // AppBar with better contrast
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Color(0xFFF1F5F9),
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF1F5F9),
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFF1F5F9),
        ),
      ),
      
      // Cards with better visibility
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1E293B),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      
      // Text theme with high contrast
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9)),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9)),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9)),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE2E8F0)),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFE2E8F0)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE2E8F0)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFCBD5E1)),
        bodySmall: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1)),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFE2E8F0)),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFCBD5E1)),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
      ),
      
      // Icon theme with better visibility
      iconTheme: const IconThemeData(
        color: Color(0xFFE2E8F0),
        size: 24,
      ),
      
      // List tile theme
      listTileTheme: const ListTileThemeData(
        textColor: Color(0xFFE2E8F0),
        iconColor: Color(0xFFE2E8F0),
      ),
      
      // Divider with subtle contrast
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155),
        thickness: 1,
      ),
      
      // Elevated buttons with better contrast
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      
      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE2E8F0),
          side: const BorderSide(color: Color(0xFF475569)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Input fields with high contrast
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        prefixStyle: const TextStyle(color: Color(0xFFE2E8F0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      
      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return const Color(0xFF64748B);
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return const Color(0xFF334155);
        }),
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      
      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return const Color(0xFF64748B);
        }),
      ),
      
      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: const Color(0xFF334155),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.2),
      ),
      
      // FAB theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF1E293B),
        modalBackgroundColor: Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E293B),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF1F5F9),
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFFCBD5E1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF334155),
        contentTextStyle: const TextStyle(color: Color(0xFFF1F5F9)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
