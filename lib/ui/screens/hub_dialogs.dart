import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_state.dart';
import '../../core/models/goal.dart';
import '../../core/models/project.dart';
import '../../core/constants/index.dart';

/// Update Goal Progress Dialog
void showUpdateGoalProgressDialog(BuildContext context, Goal goal) {
  double sliderValue = goal.currentValue;
  final notesController = TextEditingController();
  final maxValue = goal.targetValue ?? 100.0;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Update Goal Progress'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.goalPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(color: AppColors.goalPrimary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${sliderValue.toInt()} / ${maxValue.toInt()} ${goal.unit ?? ''}',
                          style: const TextStyle(
                            fontSize: AppConstants.fontLarge,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goalPrimary,
                          ),
                        ),
                        Text(
                          '${((sliderValue / maxValue) * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: AppConstants.fontMedium,
                            fontWeight: FontWeight.w600,
                            color: AppColors.goalPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppConstants.spacing12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                      child: LinearProgressIndicator(
                        value: (sliderValue / maxValue).clamp(0.0, 1.0),
                        minHeight: AppConstants.progressBarHeight,
                        backgroundColor: AppColors.goalPrimary.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goalPrimary),
                      ),
                    ),
                    SizedBox(height: AppConstants.spacing12),
                    Slider(
                      value: sliderValue,
                      min: 0,
                      max: maxValue,
                      divisions: maxValue.toInt(),
                      label: '${sliderValue.toInt()}',
                      onChanged: (value) => setState(() => sliderValue = value),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.spacing16),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add notes about this update...',
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final appState = Provider.of<AppState>(context, listen: false);
              final newProgress = GoalProgress(
                id: DateTime.now().toString(),
                goalId: goal.id,
                value: sliderValue,
                notes: notesController.text.isEmpty ? null : notesController.text,
                recordedAt: DateTime.now(),
              );
              final updatedHistory = [...?goal.progressHistory, newProgress];
              final newProgressPercent = ((sliderValue / maxValue) * 100).toInt();
              final updated = goal.copyWith(
                currentValue: sliderValue,
                progressPercent: newProgressPercent.clamp(0, 100),
                progressHistory: updatedHistory,
                updatedAt: DateTime.now(),
              );
              await appState.updateGoal(updated);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Goal progress updated!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.goalPrimary),
            child: const Text('Update'),
          ),
        ],
      ),
    ),
  );
}

/// Update Project Progress Dialog
void showUpdateProjectProgressDialog(BuildContext context, Project project) {
  int sliderValue = project.progressPercent;
  final notesController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Update Project Progress'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.projectPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(color: AppColors.projectPrimary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$sliderValue%',
                          style: const TextStyle(
                            fontSize: AppConstants.fontXLarge,
                            fontWeight: FontWeight.w700,
                            color: AppColors.projectPrimary,
                          ),
                        ),
                        Text(
                          sliderValue >= 100 ? 'Completed' : 'In Progress',
                          style: TextStyle(
                            fontSize: AppConstants.fontSmall,
                            fontWeight: FontWeight.w600,
                            color: sliderValue >= 100 ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppConstants.spacing12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                      child: LinearProgressIndicator(
                        value: sliderValue / 100,
                        minHeight: AppConstants.progressBarHeight,
                        backgroundColor: AppColors.projectPrimary.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.projectPrimary),
                      ),
                    ),
                    SizedBox(height: AppConstants.spacing12),
                    Slider(
                      value: sliderValue.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 20,
                      label: '$sliderValue%',
                      onChanged: (value) => setState(() => sliderValue = value.toInt()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.spacing16),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add notes about this update...',
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final appState = Provider.of<AppState>(context, listen: false);
              final newProgress = ProjectProgress(
                id: DateTime.now().toString(),
                projectId: project.id,
                progressPercent: sliderValue,
                notes: notesController.text.isEmpty ? null : notesController.text,
                recordedAt: DateTime.now(),
              );
              final updatedHistory = [...?project.progressHistory, newProgress];
              final updated = project.copyWith(
                progressPercent: sliderValue,
                status: sliderValue >= 100 ? 2 : 1,
                progressHistory: updatedHistory,
                updatedAt: DateTime.now(),
              );
              await appState.updateProject(updated);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Project progress updated!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.projectPrimary),
            child: const Text('Update'),
          ),
        ],
      ),
    ),
  );
}
