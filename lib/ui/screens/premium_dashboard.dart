import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_state.dart';

class PremiumDashboard extends StatefulWidget {
  const PremiumDashboard({super.key});

  @override
  State<PremiumDashboard> createState() => _PremiumDashboardState();
}

class _PremiumDashboardState extends State<PremiumDashboard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          // Calculate real statistics
          final totalTasks = appState.tasks.length;
          final completedTasks = appState.tasks.where((t) => t.status == 1).length;
          final totalTodos = appState.todos.length;
          final completedTodos = appState.todos.where((t) => t.status == 1).length;
          final totalHabits = appState.habits.length;
          final completedHabits = appState.habits.where((h) => h.streakCurrent > 0).length;
          final totalProjects = appState.projects.length;

          final totalIncome = appState.financeEntries
              .where((e) => e.type == 'income')
              .fold<double>(0, (sum, e) => sum + (e.amount ?? 0));
          final totalExpense = appState.financeEntries
              .where((e) => e.type == 'expense')
              .fold<double>(0, (sum, e) => sum + (e.amount ?? 0));
          final netBalance = totalIncome - totalExpense;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Premium Header with Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome back! Let\'s make today productive',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.95),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Quick Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildHeaderStat(
                                '$completedTasks/$totalTasks',
                                'Tasks',
                                Icons.task_alt_rounded,
                              ),
                              _buildHeaderStat(
                                '$completedTodos/$totalTodos',
                                'Todos',
                                Icons.check_circle_rounded,
                              ),
                              _buildHeaderStat(
                                '$completedHabits/$totalHabits',
                                'Habits',
                                Icons.local_fire_department_rounded,
                              ),
                              _buildHeaderStat(
                                '$totalProjects',
                                'Projects',
                                Icons.folder_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Today's Progress Section
                      _buildSectionHeader('Today\'s Progress', isDark),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          _buildProgressCard(
                            'Tasks',
                            completedTasks,
                            totalTasks,
                            Icons.task_alt_rounded,
                            Colors.blue,
                            isDark,
                          ),
                          _buildProgressCard(
                            'Todos',
                            completedTodos,
                            totalTodos,
                            Icons.check_circle_rounded,
                            Colors.green,
                            isDark,
                          ),
                          _buildProgressCard(
                            'Habits',
                            completedHabits,
                            totalHabits,
                            Icons.local_fire_department_rounded,
                            Colors.orange,
                            isDark,
                          ),
                          _buildProgressCard(
                            'Projects',
                            totalProjects,
                            totalProjects,
                            Icons.folder_rounded,
                            Colors.purple,
                            isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Financial Overview Section
                      _buildSectionHeader('Financial Overview', isDark),
                      const SizedBox(height: 16),
                      _buildFinancialOverview(
                        totalIncome,
                        totalExpense,
                        netBalance,
                        isDark,
                      ),
                      const SizedBox(height: 32),

                      // Comprehensive Analytics Section
                      _buildSectionHeader('Detailed Analytics', isDark),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildAnalyticsCard(
                            'Task Completion',
                            totalTasks > 0
                                ? '${((completedTasks / totalTasks) * 100).toStringAsFixed(0)}%'
                                : '0%',
                            Icons.trending_up_rounded,
                            Colors.blue,
                            isDark,
                          ),
                          _buildAnalyticsCard(
                            'Todo Progress',
                            totalTodos > 0
                                ? '${((completedTodos / totalTodos) * 100).toStringAsFixed(0)}%'
                                : '0%',
                            Icons.check_circle_rounded,
                            Colors.cyan,
                            isDark,
                          ),
                          _buildAnalyticsCard(
                            'Habit Streak',
                            '${appState.habits.fold<int>(0, (max, h) => h.streakLongest > max ? h.streakLongest : max)} days',
                            Icons.local_fire_department_rounded,
                            Colors.orange,
                            isDark,
                          ),
                          _buildAnalyticsCard(
                            'Active Habits',
                            '${completedHabits}/$totalHabits',
                            Icons.favorite_rounded,
                            Colors.red,
                            isDark,
                          ),
                          _buildAnalyticsCard(
                            'Net Balance',
                            '₹${netBalance.toStringAsFixed(0)}',
                            Icons.account_balance_rounded,
                            Colors.green,
                            isDark,
                          ),
                          _buildAnalyticsCard(
                            'Savings Rate',
                            totalIncome > 0
                                ? '${(((totalIncome - totalExpense) / totalIncome) * 100).toStringAsFixed(0)}%'
                                : '0%',
                            Icons.savings_rounded,
                            Colors.purple,
                            isDark,
                          ),
                          _buildAnalyticsCard(
                            'Total Projects',
                            '$totalProjects',
                            Icons.folder_rounded,
                            Colors.indigo,
                            isDark,
                          ),
                          _buildAnalyticsCard(
                            'Total Notes',
                            '${appState.notes.length}',
                            Icons.note_rounded,
                            Colors.pink,
                            isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildProgressCard(
    String label,
    int completed,
    int total,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    final percentage = total > 0 ? (completed / total * 100).toInt() : 0;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: total > 0 ? completed / total : 0,
                    minHeight: 6,
                    backgroundColor: color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$completed/$total',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview(
    double income,
    double expense,
    double balance,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFinanceItem(
                    'Income',
                    '₹${income.toStringAsFixed(0)}',
                    Icons.trending_up_rounded,
                    Colors.green,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinanceItem(
                    'Expense',
                    '₹${expense.toStringAsFixed(0)}',
                    Icons.trending_down_rounded,
                    Colors.red,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Balance',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${balance.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: balance >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    balance >= 0
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: balance >= 0 ? Colors.green : Colors.red,
                    size: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(
    String label,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        // Quick access navigation will be handled by parent
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $label...'),
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? const Color(0xFFF1F5F9)
                  : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌅';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }
}
