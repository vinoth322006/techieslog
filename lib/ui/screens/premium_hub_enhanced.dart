import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_state.dart';
import '../../core/models/habit.dart';
import '../../core/models/goal.dart';
import '../../core/models/project.dart';
import '../../core/constants/index.dart';
import '../../core/animations/index.dart';
import '../../ui/widgets/common/index.dart';
import 'project_detail_screen.dart';
import 'goal_detail_screen.dart';
import 'hub_dialogs.dart';

/// Enhanced Premium Hub with modern design system
class PremiumHubEnhanced extends StatefulWidget {
  const PremiumHubEnhanced({super.key});

  @override
  State<PremiumHubEnhanced> createState() => _PremiumHubEnhancedState();
}

class _PremiumHubEnhancedState extends State<PremiumHubEnhanced>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Enhanced Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.warning,
                indicatorWeight: 3,
                labelColor: AppColors.warning,
                unselectedLabelColor: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                labelStyle: const TextStyle(
                  fontSize: AppConstants.fontLarge,
                  fontWeight: FontWeight.w800,
                ),
                tabs: const [
                  Tab(text: 'Habits'),
                  Tab(text: 'Goals'),
                  Tab(text: 'Projects'),
                ],
              ),
            ),
          ),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                HabitsTabEnhanced(),
                GoalsTabEnhanced(),
                ProjectsTabEnhanced(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Enhanced Habits Tab
class HabitsTabEnhanced extends StatelessWidget {
  const HabitsTabEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final habits = appState.habits;
        final activeHabits = habits.where((h) => h.isActive).length;
        final todayCompleted = 0; // TODO: Implement today's completed count

        return SingleChildScrollView(
          padding: AppConstants.screenPaddingMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Header
              SlideFromTop(
                child: _buildHabitsHeader(
                  context,
                  totalHabits: habits.length,
                  activeHabits: activeHabits,
                  todayCompleted: todayCompleted,
                ),
              ),
              SizedBox(height: AppConstants.spacing20),
              
              // Add Habit Button
              SlideFromBottom(
                delay: 100,
                child: _buildAddButton(
                  context,
                  'Add New Habit',
                  Icons.add_rounded,
                  AppColors.warning,
                  () => _showAddHabitDialog(context),
                ),
              ),
              SizedBox(height: AppConstants.spacing20),
              
              // Habits List
              if (habits.isEmpty)
                FadeIn(
                  delay: 200,
                  child: const AppEmptyStateNoData(
                    title: 'No Habits Yet',
                    message: 'Start building better habits today!',
                    actionText: 'Add Your First Habit',
                  ),
                )
              else
                _buildHabitsList(habits),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitsHeader(
    BuildContext context, {
    required int totalHabits,
    required int activeHabits,
    required int todayCompleted,
  }) {
    return AppCardGradient(
      gradient: const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Habit Tracker',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: AppConstants.fontMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppConstants.spacing8),
                  Text(
                    '$totalHabits',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontDisplayLarge,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Total Habits',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: AppConstants.fontSmall,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: const Icon(
                  Icons.track_changes_rounded,
                  color: Colors.white,
                  size: AppConstants.iconXXLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacing16),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  'Active',
                  '$activeHabits',
                  Colors.white.withOpacity(0.2),
                ),
              ),
              SizedBox(width: AppConstants.spacing12),
              Expanded(
                child: _buildStatBox(
                  'Today',
                  '$todayCompleted',
                  Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList(List<Habit> habits) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return SlideFromRight(
          delay: index * 50,
          child: Padding(
            padding: EdgeInsets.only(bottom: AppConstants.spacing12),
            child: _buildHabitCard(context, habits[index]),
          ),
        );
      },
    );
  }

  Widget _buildHabitCard(BuildContext context, Habit habit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompletedToday = false; // TODO: Implement completion tracking

    return AppCard(
      onTap: () {
        // Navigate to habit detail
      },
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: Icon(
                  isCompletedToday ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isCompletedToday ? AppColors.success : AppColors.warning,
                  size: AppConstants.iconLarge,
                ),
              ),
              SizedBox(width: AppConstants.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: TextStyle(
                        fontSize: AppConstants.fontLarge,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    if (habit.description != null) ...[
                      SizedBox(height: AppConstants.spacing4),
                      Text(
                        habit.description!,
                        style: TextStyle(
                          fontSize: AppConstants.fontSmall,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              AppBadgeSmall(
                text: '${habit.streakCurrent}',
                backgroundColor: AppColors.warning,
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacing12),
          AppProgressBar(
            value: habit.totalCheckIns / 30,
            progressColor: AppColors.warning,
            showPercentage: false,
            label: '${habit.totalCheckIns} check-ins completed',
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppConstants.fontXXLarge,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: AppConstants.fontSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    // TODO: Implement add habit dialog
  }
}

/// Enhanced Goals Tab
class GoalsTabEnhanced extends StatelessWidget {
  const GoalsTabEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final goals = appState.goals;
        final activeGoals = goals.where((g) => g.status == 1).length;
        final completedGoals = goals.where((g) => g.status == 2).length;

        return SingleChildScrollView(
          padding: AppConstants.screenPaddingMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Header
              SlideFromTop(
                child: _buildGoalsHeader(
                  context,
                  totalGoals: goals.length,
                  activeGoals: activeGoals,
                  completedGoals: completedGoals,
                ),
              ),
              SizedBox(height: AppConstants.spacing20),
              
              // Add Goal Button
              SlideFromBottom(
                delay: 100,
                child: _buildAddButton(
                  context,
                  'Add New Goal',
                  Icons.add_rounded,
                  AppColors.goalPrimary,
                  () => _showAddGoalDialog(context),
                ),
              ),
              SizedBox(height: AppConstants.spacing20),
              
              // Goals List
              if (goals.isEmpty)
                FadeIn(
                  delay: 200,
                  child: const AppEmptyStateNoData(
                    title: 'No Goals Yet',
                    message: 'Set your first goal and start achieving!',
                    actionText: 'Add Your First Goal',
                  ),
                )
              else
                _buildGoalsList(goals),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalsHeader(
    BuildContext context, {
    required int totalGoals,
    required int activeGoals,
    required int completedGoals,
  }) {
    return AppCardGradient(
      gradient: AppColors.goalGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goal Tracker',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: AppConstants.fontMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppConstants.spacing8),
                  Text(
                    '$totalGoals',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontDisplayLarge,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Total Goals',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: AppConstants.fontSmall,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: Colors.white,
                  size: AppConstants.iconXXLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacing16),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  'Active',
                  '$activeGoals',
                  Colors.white.withOpacity(0.2),
                ),
              ),
              SizedBox(width: AppConstants.spacing12),
              Expanded(
                child: _buildStatBox(
                  'Completed',
                  '$completedGoals',
                  Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList(List<Goal> goals) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return SlideFromRight(
          delay: index * 50,
          child: Padding(
            padding: EdgeInsets.only(bottom: AppConstants.spacing12),
            child: _buildGoalCard(context, goals[index]),
          ),
        );
      },
    );
  }

  Widget _buildGoalCard(BuildContext context, Goal goal) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailScreen(goal: goal),
          ),
        );
      },
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: TextStyle(
                    fontSize: AppConstants.fontXLarge,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              PriorityBadge(priority: goal.priority, showIcon: false),
            ],
          ),
          if (goal.category != null) ...[
            SizedBox(height: AppConstants.spacing8),
            CategoryBadge(category: goal.category!),
          ],
          SizedBox(height: AppConstants.spacing12),
          AppProgressBar(
            value: goal.progressPercent / 100,
            progressColor: AppColors.goalPrimary,
            showPercentage: true,
            label: '${goal.currentValue.toInt()} / ${goal.targetValue?.toInt() ?? 100} ${goal.unit ?? ''}',
          ),
          SizedBox(height: AppConstants.spacing12),
          Row(
            children: [
              Expanded(
                child: AppButtonSmall(
                  text: 'Update Progress',
                  icon: Icons.trending_up_rounded,
                  backgroundColor: AppColors.goalPrimary,
                  onPressed: () => _showUpdateProgressDialog(context, goal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppConstants.fontXXLarge,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: AppConstants.fontSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    // TODO: Implement add goal dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Goal dialog - Coming soon!')),
    );
  }

  void _showUpdateProgressDialog(BuildContext context, Goal goal) {
    showUpdateGoalProgressDialog(context, goal);
  }
}

/// Enhanced Projects Tab
class ProjectsTabEnhanced extends StatelessWidget {
  const ProjectsTabEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final projects = appState.projects;
        final activeProjects = projects.where((p) => p.status == 1).length;
        final completedProjects = projects.where((p) => p.status == 2).length;

        return SingleChildScrollView(
          padding: AppConstants.screenPaddingMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Header
              SlideFromTop(
                child: _buildProjectsHeader(
                  context,
                  totalProjects: projects.length,
                  activeProjects: activeProjects,
                  completedProjects: completedProjects,
                ),
              ),
              SizedBox(height: AppConstants.spacing20),
              
              // Add Project Button
              SlideFromBottom(
                delay: 100,
                child: _buildAddButton(
                  context,
                  'Add New Project',
                  Icons.add_rounded,
                  AppColors.projectPrimary,
                  () => _showAddProjectDialog(context),
                ),
              ),
              SizedBox(height: AppConstants.spacing20),
              
              // Projects List
              if (projects.isEmpty)
                FadeIn(
                  delay: 200,
                  child: const AppEmptyStateNoData(
                    title: 'No Projects Yet',
                    message: 'Start your first project today!',
                    actionText: 'Add Your First Project',
                  ),
                )
              else
                _buildProjectsList(projects),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectsHeader(
    BuildContext context, {
    required int totalProjects,
    required int activeProjects,
    required int completedProjects,
  }) {
    return AppCardGradient(
      gradient: AppColors.projectGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Manager',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: AppConstants.fontMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppConstants.spacing8),
                  Text(
                    '$totalProjects',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontDisplayLarge,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Total Projects',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: AppConstants.fontSmall,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: const Icon(
                  Icons.folder_rounded,
                  color: Colors.white,
                  size: AppConstants.iconXXLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacing16),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  'Active',
                  '$activeProjects',
                  Colors.white.withOpacity(0.2),
                ),
              ),
              SizedBox(width: AppConstants.spacing12),
              Expanded(
                child: _buildStatBox(
                  'Completed',
                  '$completedProjects',
                  Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList(List<Project> projects) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return SlideFromRight(
          delay: index * 50,
          child: Padding(
            padding: EdgeInsets.only(bottom: AppConstants.spacing12),
            child: _buildProjectCard(context, projects[index]),
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailScreen(project: project),
          ),
        );
      },
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project.title,
                  style: TextStyle(
                    fontSize: AppConstants.fontXLarge,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              PriorityBadge(priority: project.priority, showIcon: false),
            ],
          ),
          SizedBox(height: AppConstants.spacing8),
          Row(
            children: [
              if (project.category != null) ...[
                CategoryBadge(category: project.category!),
                SizedBox(width: AppConstants.spacing8),
              ],
              StatusBadge(status: project.status, showIcon: false),
            ],
          ),
          SizedBox(height: AppConstants.spacing12),
          AppProgressBar(
            value: project.progressPercent / 100,
            progressColor: AppColors.projectPrimary,
            showPercentage: true,
          ),
          SizedBox(height: AppConstants.spacing12),
          Row(
            children: [
              Expanded(
                child: AppButtonSmall(
                  text: 'Update Progress',
                  icon: Icons.trending_up_rounded,
                  backgroundColor: AppColors.projectPrimary,
                  onPressed: () => _showUpdateProgressDialog(context, project),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppConstants.fontXXLarge,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: AppConstants.fontSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    // TODO: Implement add project dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Project dialog - Coming soon!')),
    );
  }

  void _showUpdateProgressDialog(BuildContext context, Project project) {
    showUpdateProjectProgressDialog(context, project);
  }
}
