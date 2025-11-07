import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/goal.dart';
import '../../core/providers/app_state.dart';

class GoalDetailScreen extends StatefulWidget {
  final Goal goal;

  const GoalDetailScreen({super.key, required this.goal});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late Goal _currentGoal;

  @override
  void initState() {
    super.initState();
    _currentGoal = widget.goal;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        // Get the latest goal from AppState
        final updatedGoal = appState.goals.firstWhere(
          (g) => g.id == _currentGoal.id,
          orElse: () => _currentGoal,
        );
        _currentGoal = updatedGoal;

        return Scaffold(
          appBar: AppBar(
            title: Text(_currentGoal.title),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(isDark),
                const SizedBox(height: 20),
                _buildDetailsSection(isDark),
                const SizedBox(height: 20),
                _buildTimelineSection(isDark),
                const SizedBox(height: 20),
                _buildProgressSection(isDark),
                const SizedBox(height: 20),
                _buildReasonStrategySection(isDark),
                if (_currentGoal.progressHistory != null &&
                    _currentGoal.progressHistory!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildProgressHistorySection(isDark),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUpdateProgressDialog() {
    double sliderValue = _currentGoal.currentValue.toDouble();
    final notesController = TextEditingController();
    final maxValue = _currentGoal.targetValue ?? 100.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Update Progress'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Goal Progress Update',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.pink.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${sliderValue.toInt()}/${maxValue.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.pink,
                            ),
                          ),
                          Text(
                            '${((sliderValue / maxValue) * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: sliderValue / maxValue,
                          minHeight: 8,
                          backgroundColor: Colors.pink.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.pink),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Slider(
                        value: sliderValue,
                        min: 0,
                        max: maxValue,
                        onChanged: (value) {
                          setState(() => sliderValue = value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add notes about this progress update...',
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.pink.withOpacity(0.05),
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
              onPressed: () {
                final appState =
                    Provider.of<AppState>(context, listen: false);
                final newProgress = GoalProgress(
                  id: DateTime.now().toString(),
                  goalId: _currentGoal.id,
                  value: sliderValue,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                  recordedAt: DateTime.now(),
                );
                final updatedHistory = [...?_currentGoal.progressHistory, newProgress];
                final newProgressPercent =
                    _currentGoal.targetValue != null && _currentGoal.targetValue! > 0
                        ? ((sliderValue / _currentGoal.targetValue!) * 100).toInt()
                        : 0;
                final updated = _currentGoal.copyWith(
                  currentValue: sliderValue,
                  progressPercent: newProgressPercent.clamp(0, 100),
                  progressHistory: updatedHistory,
                  updatedAt: DateTime.now(),
                );
                appState.updateGoal(updated);
                setState(() => _currentGoal = updated);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress updated successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text('Update Progress'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.pink.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentGoal.status == 0
                    ? 'Not Started'
                    : (_currentGoal.status == 1 ? 'In Progress' : 'Completed'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'P${_currentGoal.priority}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _currentGoal.progressPercent / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${_currentGoal.progressPercent}% Complete',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Title', _currentGoal.title),
        if (_currentGoal.description != null)
          _buildDetailRow('Description', _currentGoal.description!),
        _buildDetailRow('Category', _currentGoal.category ?? 'N/A'),
        _buildDetailRow('Priority', 'P${_currentGoal.priority}'),
        _buildDetailRow('Type', _currentGoal.type ?? 'N/A'),
        if (_currentGoal.unit != null)
          _buildDetailRow('Unit', _currentGoal.unit!),
      ],
    );
  }

  Widget _buildTimelineSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        if (_currentGoal.targetDate != null)
          _buildDetailRow(
            'Target Date',
            '${_currentGoal.targetDate!.day}/${_currentGoal.targetDate!.month}/${_currentGoal.targetDate!.year}',
          ),
      ],
    );
  }

  Widget _buildProgressSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Current Value', '${_currentGoal.currentValue}'),
        _buildDetailRow('Target Value', '${_currentGoal.targetValue ?? 'N/A'}'),
        _buildDetailRow('Progress', '${_currentGoal.progressPercent}%'),
        if ((_currentGoal.milestonesCompleted ?? 0) > 0 ||
            (_currentGoal.totalMilestones ?? 0) > 0)
          _buildDetailRow(
            'Milestones',
            '${_currentGoal.milestonesCompleted}/${_currentGoal.totalMilestones}',
          ),
      ],
    );
  }

  Widget _buildReasonStrategySection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Goal Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        if (_currentGoal.reason != null)
          _buildDetailRow('Why (Reason)', _currentGoal.reason!),
        if (_currentGoal.strategy != null)
          _buildDetailRow('How (Strategy)', _currentGoal.strategy!),
        if (_currentGoal.notes != null)
          _buildDetailRow('Notes', _currentGoal.notes!),
      ],
    );
  }

  Widget _buildProgressHistorySection(bool isDark) {
    // Sort history by date (newest first)
    final sortedHistory = List<GoalProgress>.from(_currentGoal.progressHistory!)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history_rounded,
              color: Colors.pink,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Progress History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${sortedHistory.length} updates',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedHistory.length,
          itemBuilder: (context, index) {
            final progress = sortedHistory[index];
            final isLatest = index == 0;
            final progressPercent = (_currentGoal.targetValue != null && _currentGoal.targetValue! > 0)
                ? ((progress.value / _currentGoal.targetValue!) * 100).toInt()
                : 0;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isLatest
                    ? LinearGradient(
                        colors: [
                          Colors.pink.withOpacity(0.15),
                          Colors.pink.withOpacity(0.05),
                        ],
                      )
                    : null,
                color: isLatest ? null : Colors.pink.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLatest
                      ? Colors.pink.withOpacity(0.4)
                      : Colors.pink.withOpacity(0.2),
                  width: isLatest ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${progress.value.toInt()} / ${_currentGoal.targetValue?.toInt() ?? 100} ${_currentGoal.unit ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isLatest ? Colors.green : Colors.pink.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isLatest ? 'Latest' : '$progressPercent%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isLatest ? Colors.white : Colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${progress.recordedAt.day}/${progress.recordedAt.month}/${progress.recordedAt.year}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          Text(
                            '${progress.recordedAt.hour.toString().padLeft(2, '0')}:${progress.recordedAt.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (progress.notes != null && progress.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withOpacity(0.2)
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.note_rounded,
                            size: 14,
                            color: Colors.pink.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              progress.notes!,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
