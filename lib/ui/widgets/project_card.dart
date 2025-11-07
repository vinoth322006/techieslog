import 'package:flutter/material.dart';
import '../../core/models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({
    Key? key,
    required this.project,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              if (project.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  project.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: project.progressPercent / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text('${project.progressPercent}% Complete'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color color;
    String label;
    
    switch (project.status) {
      case 0:
        color = Colors.grey;
        label = 'Not Started';
        break;
      case 1:
        color = Colors.blue;
        label = 'In Progress';
        break;
      case 2:
        color = Colors.green;
        label = 'Completed';
        break;
      default:
        color = Colors.red;
        label = 'Unknown';
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color),
    );
  }
}
