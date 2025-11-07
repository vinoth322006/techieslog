import 'package:flutter/material.dart';

/// App-wide color constants for consistent theming
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ==================== CATEGORY COLORS ====================
  /// Category color mapping for goals, projects, and tasks
  static const Map<String, Color> categoryColors = {
    'personal': Color(0xFF8B5CF6),    // Purple
    'career': Color(0xFF3B82F6),      // Blue
    'health': Color(0xFF10B981),      // Green
    'finance': Color(0xFFF59E0B),     // Amber
    'work': Color(0xFF06B6D4),        // Cyan
    'learning': Color(0xFF10B981),    // Green
    'creative': Color(0xFFEF4444),    // Red
    'social': Color(0xFFEC4899),      // Pink
    'family': Color(0xFFF97316),      // Orange
    'hobby': Color(0xFFA855F7),       // Purple variant
    'travel': Color(0xFF14B8A6),      // Teal
    'education': Color(0xFF6366F1),   // Indigo
    'business': Color(0xFF0EA5E9),    // Sky blue
    'fitness': Color(0xFF22C55E),     // Green variant
    'mindfulness': Color(0xFF8B5CF6), // Purple
  };

  /// Get category color with fallback
  static Color getCategoryColor(String? category) {
    if (category == null) return defaultCategory;
    return categoryColors[category.toLowerCase()] ?? defaultCategory;
  }

  /// Default category color
  static const Color defaultCategory = Color(0xFF64748B); // Slate

  // ==================== STATUS COLORS ====================
  /// Status: Not Started (Gray)
  static const Color statusNotStarted = Color(0xFF64748B);
  
  /// Status: In Progress (Amber)
  static const Color statusInProgress = Color(0xFFF59E0B);
  
  /// Status: Completed (Green)
  static const Color statusCompleted = Color(0xFF10B981);
  
  /// Status: On Hold (Orange)
  static const Color statusOnHold = Color(0xFFF97316);
  
  /// Status: Cancelled/Abandoned (Red)
  static const Color statusCancelled = Color(0xFFEF4444);
  
  /// Status: Archived (Gray)
  static const Color statusArchived = Color(0xFF94A3B8);

  /// Get status color by index
  static Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return statusNotStarted;
      case 1:
        return statusInProgress;
      case 2:
        return statusCompleted;
      case 3:
        return statusOnHold;
      case 4:
        return statusCancelled;
      default:
        return statusNotStarted;
    }
  }

  /// Get status name by index
  static String getStatusName(int status) {
    switch (status) {
      case 0:
        return 'Not Started';
      case 1:
        return 'In Progress';
      case 2:
        return 'Completed';
      case 3:
        return 'On Hold';
      case 4:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  // ==================== PRIORITY COLORS ====================
  /// Priority colors (1-5, low to critical)
  static const List<Color> priorityColors = [
    Color(0xFF64748B),  // P1 - Low (Gray)
    Color(0xFF3B82F6),  // P2 - Medium (Blue)
    Color(0xFF10B981),  // P3 - Normal (Green)
    Color(0xFFF59E0B),  // P4 - High (Amber)
    Color(0xFFEF4444),  // P5 - Critical (Red)
  ];

  /// Get priority color (1-5)
  static Color getPriorityColor(int priority) {
    if (priority < 1 || priority > 5) return priorityColors[2]; // Default to normal
    return priorityColors[priority - 1];
  }

  /// Get priority name
  static String getPriorityName(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'Normal';
      case 4:
        return 'High';
      case 5:
        return 'Critical';
      default:
        return 'Normal';
    }
  }

  // ==================== SEMANTIC COLORS ====================
  /// Success color (Green)
  static const Color success = Color(0xFF10B981);
  
  /// Warning color (Amber)
  static const Color warning = Color(0xFFF59E0B);
  
  /// Error color (Red)
  static const Color error = Color(0xFFEF4444);
  
  /// Info color (Blue)
  static const Color info = Color(0xFF3B82F6);

  // ==================== HABIT COLORS ====================
  /// Habit streak colors
  static const Color habitStreak = Color(0xFFF59E0B);
  static const Color habitCompleted = Color(0xFF10B981);
  static const Color habitMissed = Color(0xFFEF4444);
  static const Color habitPending = Color(0xFF64748B);

  // ==================== GOAL COLORS ====================
  /// Goal primary color (Pink)
  static const Color goalPrimary = Color(0xFFEC4899);
  
  /// Goal secondary color (Pink variant)
  static const Color goalSecondary = Color(0xFFF472B6);
  
  /// Goal accent color
  static const Color goalAccent = Color(0xFFFBBF24);

  // ==================== PROJECT COLORS ====================
  /// Project primary color (Purple)
  static const Color projectPrimary = Color(0xFF8B5CF6);
  
  /// Project secondary color (Purple variant)
  static const Color projectSecondary = Color(0xFFA78BFA);
  
  /// Project accent color
  static const Color projectAccent = Color(0xFF06B6D4);

  // ==================== TASK COLORS ====================
  /// Task primary color (Blue)
  static const Color taskPrimary = Color(0xFF3B82F6);
  
  /// Task secondary color (Blue variant)
  static const Color taskSecondary = Color(0xFF60A5FA);
  
  /// Task accent color
  static const Color taskAccent = Color(0xFF10B981);

  // ==================== FINANCE COLORS ====================
  /// Income color (Green)
  static const Color income = Color(0xFF10B981);
  
  /// Expense color (Red)
  static const Color expense = Color(0xFFEF4444);
  
  /// Savings color (Blue)
  static const Color savings = Color(0xFF3B82F6);
  
  /// Investment color (Purple)
  static const Color investment = Color(0xFF8B5CF6);

  // ==================== CHART COLORS ====================
  /// Chart color palette for data visualization
  static const List<Color> chartColors = [
    Color(0xFF6366F1),  // Indigo
    Color(0xFF8B5CF6),  // Purple
    Color(0xFFEC4899),  // Pink
    Color(0xFFF59E0B),  // Amber
    Color(0xFF10B981),  // Green
    Color(0xFF06B6D4),  // Cyan
    Color(0xFF3B82F6),  // Blue
    Color(0xFFEF4444),  // Red
    Color(0xFFF97316),  // Orange
    Color(0xFF14B8A6),  // Teal
  ];

  /// Get chart color by index
  static Color getChartColor(int index) {
    return chartColors[index % chartColors.length];
  }

  // ==================== GRADIENT COLORS ====================
  /// Primary gradient (Indigo to Purple)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient (Green to Cyan)
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warning gradient (Amber to Orange)
  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Error gradient (Red to Pink)
  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Goal gradient (Pink)
  static const LinearGradient goalGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Project gradient (Purple)
  static const LinearGradient projectGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== OVERLAY COLORS ====================
  /// Light overlay for dark backgrounds
  static Color lightOverlay(double opacity) => Colors.white.withOpacity(opacity);
  
  /// Dark overlay for light backgrounds
  static Color darkOverlay(double opacity) => Colors.black.withOpacity(opacity);

  // ==================== SHIMMER COLORS ====================
  /// Shimmer base color (light mode)
  static const Color shimmerBaseLight = Color(0xFFE5E7EB);
  
  /// Shimmer highlight color (light mode)
  static const Color shimmerHighlightLight = Color(0xFFF3F4F6);
  
  /// Shimmer base color (dark mode)
  static const Color shimmerBaseDark = Color(0xFF1E293B);
  
  /// Shimmer highlight color (dark mode)
  static const Color shimmerHighlightDark = Color(0xFF334155);
}
