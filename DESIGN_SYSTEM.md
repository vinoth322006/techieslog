# TechLog Design System

## 🎨 Overview
This document outlines the complete design system for the TechLog app, ensuring consistency, maintainability, and scalability across all screens and components.

---

## 📐 Constants

### Spacing (`AppConstants`)
```dart
spacing4   = 4.0   // Extra small
spacing8   = 8.0   // Small
spacing12  = 12.0  // Medium-small
spacing16  = 16.0  // Medium (most common)
spacing20  = 20.0  // Medium-large
spacing24  = 24.0  // Large
spacing32  = 32.0  // Extra large
spacing40  = 40.0  // XXL
spacing48  = 48.0  // XXXL
```

### Border Radius
```dart
radiusXSmall  = 4.0   // Extra small
radiusSmall   = 8.0   // Small
radiusMedium  = 12.0  // Medium (most common)
radiusLarge   = 16.0  // Large
radiusXLarge  = 20.0  // Extra large
radiusXXLarge = 24.0  // XXL
radiusFull    = 999.0 // Full circle
```

### Icon Sizes
```dart
iconXSmall   = 12.0  // Extra small
iconSmall    = 16.0  // Small
iconMedium   = 20.0  // Medium
iconLarge    = 24.0  // Large (most common)
iconXLarge   = 32.0  // Extra large
iconXXLarge  = 40.0  // XXL
iconXXXLarge = 48.0  // XXXL
```

### Font Sizes
```dart
fontXSmall       = 10.0  // Extra small
fontSmall        = 12.0  // Small
fontMedium       = 14.0  // Medium (body text)
fontLarge        = 16.0  // Large
fontXLarge       = 18.0  // Extra large
fontXXLarge      = 20.0  // XXL (titles)
fontXXXLarge     = 24.0  // XXXL (headers)
fontDisplay      = 28.0  // Display
fontDisplayLarge = 32.0  // Large display
```

### Animation Durations
```dart
animationXFast  = 100ms  // Extra fast
animationFast   = 150ms  // Fast
animationNormal = 300ms  // Normal (most common)
animationSlow   = 500ms  // Slow
animationXSlow  = 700ms  // Extra slow
```

---

## 🎨 Colors (`AppColors`)

### Category Colors
```dart
personal   = Purple (#8B5CF6)
career     = Blue (#3B82F6)
health     = Green (#10B981)
finance    = Amber (#F59E0B)
work       = Cyan (#06B6D4)
learning   = Green (#10B981)
creative   = Red (#EF4444)
social     = Pink (#EC4899)
family     = Orange (#F97316)
```

### Status Colors
```dart
statusNotStarted = Gray (#64748B)
statusInProgress = Amber (#F59E0B)
statusCompleted  = Green (#10B981)
statusOnHold     = Orange (#F97316)
statusCancelled  = Red (#EF4444)
```

### Priority Colors (1-5)
```dart
P1 (Low)      = Gray (#64748B)
P2 (Medium)   = Blue (#3B82F6)
P3 (Normal)   = Green (#10B981)
P4 (High)     = Amber (#F59E0B)
P5 (Critical) = Red (#EF4444)
```

### Feature Colors
```dart
Goals    = Pink (#EC4899)
Projects = Purple (#8B5CF6)
Tasks    = Blue (#3B82F6)
Habits   = Orange (#F59E0B)
```

---

## 🧩 Components

### Cards

#### AppCard (Base)
```dart
AppCard(
  child: Widget,
  padding: EdgeInsets?,
  margin: EdgeInsets?,
  color: Color?,
  borderRadius: double?,
  onTap: VoidCallback?,
  showShadow: bool = false,
)
```

#### Variants
- `AppCardSmall` - Small padding, medium radius
- `AppCardLarge` - Large padding, extra large radius, shadow
- `AppCardGradient` - Gradient background
- `AppCardOutlined` - Border instead of fill

### Buttons

#### AppButton (Base)
```dart
AppButton(
  text: String,
  onPressed: VoidCallback?,
  icon: IconData?,
  backgroundColor: Color?,
  isLoading: bool = false,
  isOutlined: bool = false,
  isText: bool = false,
)
```

#### Variants
- `AppButtonPrimary` - Primary color, white text
- `AppButtonSecondary` - Outlined with primary color
- `AppButtonSmall` - Smaller height and padding
- `AppIconButton` - Icon only with background

### Badges

#### StatusBadge
```dart
StatusBadge(
  status: int, // 0-4
  showIcon: bool = true,
)
```

#### PriorityBadge
```dart
PriorityBadge(
  priority: int, // 1-5
  showIcon: bool = true,
)
```

#### CategoryBadge
```dart
CategoryBadge(
  category: String,
  showIcon: bool = false,
)
```

### Progress Indicators

#### AppProgressBar
```dart
AppProgressBar(
  value: double, // 0.0 to 1.0
  backgroundColor: Color?,
  progressColor: Color?,
  showPercentage: bool = false,
  label: String?,
)
```

#### AppCircularProgress
```dart
AppCircularProgress(
  value: double, // 0.0 to 1.0
  size: double?,
  showPercentage: bool = true,
)
```

### Empty States

#### AppEmptyState
```dart
AppEmptyState(
  icon: IconData,
  title: String,
  message: String?,
  actionText: String?,
  onAction: VoidCallback?,
)
```

#### Variants
- `AppEmptyStateNoData` - Generic no data state
- `AppEmptyStateSearch` - No search results
- `AppEmptyStateError` - Error state

### Loading States

#### AppLoading
```dart
AppLoading(
  message: String?,
  size: double?,
)
```

#### Variants
- `AppLoadingSmall` - Small spinner
- `AppLoadingOverlay` - Full screen overlay
- `AppLoadingCard` - Shimmer card
- `AppLoadingList` - Shimmer list

### Dialogs

#### AppDialog
```dart
AppDialog.show(
  context: BuildContext,
  title: String,
  content: Widget,
  actions: List<Widget>?,
  icon: IconData?,
)
```

#### Variants
- `AppConfirmDialog` - Confirmation with yes/no
- `AppDeleteDialog` - Delete confirmation
- `AppInfoDialog` - Information display

### Bottom Sheets

#### AppBottomSheet
```dart
AppBottomSheet.show(
  context: BuildContext,
  title: String?,
  child: Widget,
  height: double?,
  showHandle: bool = true,
)
```

#### Variants
- `AppBottomSheetActions` - Action list
- `AppBottomSheetForm` - Form with submit button

---

## 🎬 Animations

### Slide Animations
```dart
SlideFromBottom(child: Widget, delay: int)
SlideFromTop(child: Widget, delay: int)
SlideFromLeft(child: Widget, delay: int)
SlideFromRight(child: Widget, delay: int)
```

### Fade Animations
```dart
FadeIn(child: Widget, delay: int)
FadeOut(child: Widget, delay: int)
StaggeredFadeIn(children: List<Widget>, staggerDelay: int)
```

### Scale Animations
```dart
ScaleIn(child: Widget, delay: int)
ScaleOut(child: Widget, delay: int)
PopAnimation(child: Widget, delay: int)
PulseAnimation(child: Widget)
```

### Shimmer
```dart
ShimmerAnimation(child: Widget)
ShimmerBox(width, height, borderRadius)
ShimmerCard(height)
ShimmerList(itemCount, itemHeight)
```

---

## 📱 Usage Examples

### Creating a Card
```dart
AppCard(
  padding: AppConstants.cardPaddingMedium,
  borderRadius: AppConstants.radiusLarge,
  showShadow: true,
  onTap: () => print('Tapped'),
  child: Column(
    children: [
      Text('Title', style: TextStyle(
        fontSize: AppConstants.fontXXLarge,
        fontWeight: FontWeight.bold,
      )),
      SizedBox(height: AppConstants.spacing12),
      AppProgressBar(
        value: 0.75,
        showPercentage: true,
      ),
    ],
  ),
)
```

### Using Animations
```dart
SlideFromBottom(
  delay: 100,
  child: AppCard(
    child: Text('Animated Card'),
  ),
)
```

### Showing Dialogs
```dart
final confirmed = await AppConfirmDialog.show(
  context: context,
  title: 'Delete Item',
  message: 'Are you sure?',
  confirmText: 'Delete',
  confirmColor: Colors.red,
);
```

### Status Badges
```dart
Row(
  children: [
    StatusBadge(status: 1), // In Progress
    SizedBox(width: AppConstants.spacing8),
    PriorityBadge(priority: 4), // High
    SizedBox(width: AppConstants.spacing8),
    CategoryBadge(category: 'work'),
  ],
)
```

---

## 🎯 Best Practices

### DO ✅
- Use constants for all spacing, sizes, and colors
- Use semantic color names (e.g., `AppColors.success`)
- Use appropriate animation durations
- Wrap lists with animations for better UX
- Use empty states when no data
- Show loading states during async operations
- Use consistent border radius across components

### DON'T ❌
- Hardcode color values (e.g., `Color(0xFF...)`)
- Hardcode spacing values (e.g., `padding: 16`)
- Use magic numbers
- Mix different border radius values
- Forget dark mode support
- Skip empty/loading states
- Use inconsistent animation speeds

---

## 🔄 Migration Guide

### Before (Hardcoded)
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFF8B5CF6),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 20, color: Colors.white),
  ),
)
```

### After (Design System)
```dart
AppCard(
  padding: AppConstants.cardPaddingMedium,
  borderRadius: AppConstants.radiusMedium,
  color: AppColors.projectPrimary,
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: AppConstants.fontXXLarge,
      color: Colors.white,
    ),
  ),
)
```

---

## 📦 Import Structure

```dart
// Constants
import 'package:techieslog/core/constants/index.dart';

// Animations
import 'package:techieslog/core/animations/index.dart';

// Common Widgets
import 'package:techieslog/ui/widgets/common/index.dart';
```

---

## 🎨 Color Usage Matrix

| Feature | Primary Color | Secondary Color | Use Case |
|---------|--------------|-----------------|----------|
| Goals | Pink (#EC4899) | Pink variant | Cards, badges, progress |
| Projects | Purple (#8B5CF6) | Purple variant | Cards, badges, progress |
| Tasks | Blue (#3B82F6) | Blue variant | Cards, badges, progress |
| Habits | Orange (#F59E0B) | Orange variant | Cards, badges, streaks |
| Finance | Green/Red | Amber | Income/Expense indicators |
| Dashboard | Indigo (#6366F1) | Purple | Stats, charts |

---

## 🚀 Next Steps

1. ✅ Constants created
2. ✅ Colors defined
3. ✅ Widgets built
4. ✅ Animations ready
5. 🔄 Refactor screens to use design system
6. ⏳ Add more specialized components
7. ⏳ Create screen templates
8. ⏳ Build interactive examples

---

**Version:** 1.0.0  
**Last Updated:** November 7, 2025  
**Status:** Foundation Complete ✅
