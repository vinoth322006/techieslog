import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/project.dart';
import '../../core/providers/app_state.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Project _currentProject;

  @override
  void initState() {
    super.initState();
    _currentProject = widget.project;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        // Get the latest project from AppState
        final updatedProject = appState.goals.isEmpty 
            ? _currentProject 
            : appState.projects.firstWhere(
                (p) => p.id == _currentProject.id,
                orElse: () => _currentProject,
              );
        _currentProject = updatedProject;

        return Scaffold(
          appBar: AppBar(
            title: Text(_currentProject.title),
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
                if (_currentProject.links != null &&
                    _currentProject.links!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildLinksSection(isDark),
                ],
                if (_currentProject.tags != null && _currentProject.tags!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildTagsSection(isDark),
                ],
                if (_currentProject.progressHistory != null &&
                    _currentProject.progressHistory!.isNotEmpty) ...[
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
    int sliderValue = _currentProject.progressPercent;
    final notesController = TextEditingController();

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
                  'Project Progress Update',
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
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.purple.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$sliderValue%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            sliderValue >= 100 ? 'Completed' : 'In Progress',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sliderValue >= 100
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: sliderValue / 100,
                          minHeight: 8,
                          backgroundColor: Colors.purple.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.purple),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Slider(
                        value: sliderValue.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: '$sliderValue%',
                        onChanged: (value) {
                          setState(() => sliderValue = value.toInt());
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
                    fillColor: Colors.purple.withOpacity(0.05),
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
                final updated = _currentProject.copyWith(
                  progressPercent: sliderValue,
                  status: sliderValue >= 100 ? 2 : 1,
                  notes: notesController.text.isEmpty
                      ? _currentProject.notes
                      : (_currentProject.notes ?? '') + '\n[${DateTime.now().toString().split('.')[0]}] ${notesController.text}',
                  updatedAt: DateTime.now(),
                );
                appState.updateProject(updated);
                setState(() => _currentProject = updated);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress updated successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
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
          colors: [Colors.purple, Colors.purple.withOpacity(0.6)],
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
                _currentProject.status == 0
                    ? 'Not Started'
                    : (_currentProject.status == 1 ? 'In Progress' : 'Completed'),
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
                  'P${_currentProject.priority}',
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
              value: _currentProject.progressPercent / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${_currentProject.progressPercent}% Complete',
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
        _buildDetailRow('Title', _currentProject.title),
        if (_currentProject.description != null)
          _buildDetailRow('Description', _currentProject.description!),
        if (_currentProject.owner != null)
          _buildDetailRow('Owner', _currentProject.owner!),
        _buildDetailRow('Category', _currentProject.category ?? 'N/A'),
        _buildDetailRow('Priority', 'P${_currentProject.priority}'),
        if (_currentProject.notes != null)
          _buildDetailRow('Notes', _currentProject.notes!),
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
        if (_currentProject.startDate != null)
          _buildDetailRow(
            'Start Date',
            '${_currentProject.startDate!.day}/${_currentProject.startDate!.month}/${_currentProject.startDate!.year}',
          ),
        if (_currentProject.targetDate != null)
          _buildDetailRow(
            'Target Date',
            '${_currentProject.targetDate!.day}/${_currentProject.targetDate!.month}/${_currentProject.targetDate!.year}',
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
        _buildDetailRow('Progress', '${_currentProject.progressPercent}%'),
        if (_currentProject.tasksCompleted > 0 || _currentProject.totalTasks > 0)
          _buildDetailRow(
            'Tasks',
            '${_currentProject.tasksCompleted}/${_currentProject.totalTasks}',
          ),
      ],
    );
  }

  Widget _buildLinksSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Links',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _currentProject.links!.map((link) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getLinkIcon(link.type),
                  const SizedBox(width: 6),
                  Text(
                    link.label ?? link.type,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _currentProject.tags!.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                ),
              ),
            );
          }).toList(),
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

  Widget _buildProgressHistorySection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _currentProject.progressHistory!.length,
          itemBuilder: (context, index) {
            final progress = _currentProject.progressHistory![index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.purple.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${progress.progressPercent}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${progress.recordedAt.day}/${progress.recordedAt.month}/${progress.recordedAt.year}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  if (progress.notes != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      progress.notes!,
                      style: const TextStyle(
                        fontSize: 11,
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

  Icon _getLinkIcon(String type) {
    switch (type) {
      case 'github':
        return const Icon(Icons.code_rounded, size: 18, color: Colors.black);
      case 'linkedin':
        return const Icon(Icons.business_rounded, size: 18, color: Colors.blue);
      case 'figma':
        return const Icon(Icons.palette_rounded, size: 18, color: Colors.purple);
      case 'notion':
        return const Icon(Icons.note_rounded, size: 18, color: Colors.grey);
      case 'web':
        return const Icon(Icons.language_rounded, size: 18, color: Colors.blue);
      default:
        return const Icon(Icons.link_rounded, size: 18, color: Colors.grey);
    }
  }
}
