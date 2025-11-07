import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_state.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/utils/responsive.dart';
import 'premium_dashboard.dart';
import 'premium_work_complete.dart';
import 'premium_hub_enhanced.dart';
import 'premium_logs_calendar.dart';
import 'finance_screen.dart';
import 'settings_screen.dart';

class ModernMainNavigation extends StatefulWidget {
  const ModernMainNavigation({super.key});

  @override
  State<ModernMainNavigation> createState() => _ModernMainNavigationState();
}

class _ModernMainNavigationState extends State<ModernMainNavigation>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;

  final List<NavItem> navItems = [
    NavItem(
      icon: Icons.home_rounded,
      label: 'Dashboard',
      description: 'Overview & Stats',
    ),
    NavItem(
      icon: Icons.work_rounded,
      label: 'Work',
      description: 'Tasks & Notes',
    ),
    NavItem(
      icon: Icons.hub_rounded,
      label: 'Hub',
      description: 'Habits, Goals, Projects',
    ),
    NavItem(
      icon: Icons.trending_up_rounded,
      label: 'Finance',
      description: 'Money Management',
    ),
    NavItem(
      icon: Icons.calendar_today_rounded,
      label: 'Journal',
      description: 'Logs & Reflections',
    ),
    NavItem(
      icon: Icons.settings_rounded,
      label: 'Settings',
      description: 'Preferences',
    ),
  ];

  late final List<Widget> _screens = [
    const PremiumDashboard(),
    const PremiumWorkComplete(),
    const PremiumHubEnhanced(),
    const FinanceScreen(),
    const PremiumLogsCalendar(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Responsive().init(context);
    final isDesktop = Responsive.isDesktop;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            _buildSideNavBar(isDark),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildModernNavBar(isDark),
    );
  }

  Widget _buildSideNavBar(bool isDark) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'TechLog',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: navItems.length,
                itemBuilder: (context, index) => _buildSideNavItem(index, isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavItem(int index, bool isDark) {
    final item = navItems[index];
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
                    ),
                  ),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNavBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              navItems.length,
              (index) => _buildNavItem(index, isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, bool isDark) {
    final item = navItems[index];
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 28,
            color: isSelected
                ? Theme.of(context).primaryColor
                : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final String description;

  NavItem({
    required this.icon,
    required this.label,
    required this.description,
  });
}
