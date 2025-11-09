import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_state.dart';
import '../../core/models/habit.dart';
import '../../core/models/goal.dart';
import '../../core/models/project.dart';
import 'project_detail_screen.dart';
import 'goal_detail_screen.dart';

class ProjectEditorSheet extends StatefulWidget {
  final Project project;

  const ProjectEditorSheet({super.key, required this.project});

  @override
  State<ProjectEditorSheet> createState() => _ProjectEditorSheetState();
}

class _ProjectEditorSheetState extends State<ProjectEditorSheet> {
  late Project _currentProject;
  bool _isEditing = false;

  // Edit controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _ownerController;
  late TextEditingController _notesController;
  String _selectedCategory = '';
  int _selectedPriority = 1;
  DateTime? _selectedStartDate;
  DateTime? _selectedTargetDate;
  List<ProjectLink> _editingLinks = [];
  List<String> _editingTags = [];

  @override
  void initState() {
    super.initState();
    _currentProject = widget.project;
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: _currentProject.title);
    _descriptionController =
        TextEditingController(text: _currentProject.description ?? '');
    _ownerController = TextEditingController(text: _currentProject.owner ?? '');
    _notesController = TextEditingController(text: _currentProject.notes ?? '');
    _selectedCategory = _currentProject.category ?? 'Development';
    _selectedPriority = _currentProject.priority;
    _selectedStartDate = _currentProject.startDate;
    _selectedTargetDate = _currentProject.targetDate;
    _editingLinks = List.from(_currentProject.links ?? []);
    _editingTags = List.from(_currentProject.tags ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ownerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final appState = Provider.of<AppState>(context, listen: false);
    final updated = _currentProject.copyWith(
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      owner: _ownerController.text.isEmpty ? null : _ownerController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      category: _selectedCategory,
      priority: _selectedPriority,
      startDate: _selectedStartDate,
      targetDate: _selectedTargetDate,
      links: _editingLinks.isEmpty ? null : _editingLinks,
      tags: _editingTags.isEmpty ? null : _editingTags,
      updatedAt: DateTime.now(),
    );
    appState.updateProject(updated);
    setState(() {
      _currentProject = updated;
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project updated successfully!')),
    );
  }

  void _addLink() {
    String selectedType = 'web';
    final urlController = TextEditingController();
    final labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Add Project Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                onChanged: (value) =>
                    setModalState(() => selectedType = value ?? 'web'),
                items: ['github', 'linkedin', 'web', 'figma', 'notion', 'other']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Link Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  hintText: 'https://example.com',
                  labelText: 'URL *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  hintText: 'Optional label',
                  labelText: 'Label',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (urlController.text.isNotEmpty) {
                  final link = ProjectLink(
                    type: selectedType,
                    url: urlController.text,
                    label: labelController.text.isEmpty
                        ? null
                        : labelController.text,
                  );
                  setState(() => _editingLinks.add(link));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTag() {
    final tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: tagController,
          decoration: const InputDecoration(
            hintText: 'Enter tag name',
            labelText: 'Tag',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (tagController.text.isNotEmpty &&
                  !_editingTags.contains(tagController.text)) {
                setState(() => _editingTags.add(tagController.text));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _currentProject.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () => setState(() => _isEditing = true),
                  )
                else ...[
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _initializeControllers();
                      setState(() => _isEditing = false);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_rounded),
                    onPressed: _saveChanges,
                  ),
                ],
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _isEditing ? _buildEditMode(isDark) : _buildViewMode(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewMode(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusCard(isDark),
        const SizedBox(height: 20),
        _buildSection('Details', isDark, [
          _buildRow('Title', _currentProject.title),
          if (_currentProject.description != null)
            _buildRow('Description', _currentProject.description!),
          if (_currentProject.owner != null)
            _buildRow('Owner', _currentProject.owner!),
          _buildRow('Category', _currentProject.category ?? 'N/A'),
          _buildRow('Priority', 'P${_currentProject.priority}'),
          if (_currentProject.notes != null)
            _buildRow('Notes', _currentProject.notes!),
        ]),
        if (_currentProject.startDate != null || _currentProject.targetDate != null) ...[
          const SizedBox(height: 16),
          _buildSection('Timeline', isDark, [
            if (_currentProject.startDate != null)
              _buildRow('Start Date',
                  '${_currentProject.startDate!.day}/${_currentProject.startDate!.month}/${_currentProject.startDate!.year}'),
            if (_currentProject.targetDate != null)
              _buildRow('Target Date',
                  '${_currentProject.targetDate!.day}/${_currentProject.targetDate!.month}/${_currentProject.targetDate!.year}'),
          ]),
        ],
        if (_currentProject.links != null && _currentProject.links!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSection('Links', isDark, [
            Wrap(
              spacing: 8,
              children: _currentProject.links!.map((link) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getLinkIcon(link.type),
                      const SizedBox(width: 6),
                      Text(link.label ?? link.type,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ]),
        ],
        if (_currentProject.tags != null && _currentProject.tags!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSection('Tags', isDark, [
            Wrap(
              spacing: 6,
              children: _currentProject.tags!.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(tag,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber)),
                );
              }).toList(),
            ),
          ]),
        ],
      ],
    );
  }

  Widget _buildEditMode(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title *',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ownerController,
          decoration: const InputDecoration(
            labelText: 'Owner/Lead',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          onChanged: (value) =>
              setState(() => _selectedCategory = value ?? 'Development'),
          items: ['Development', 'Design', 'Marketing', 'Research', 'Other']
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text('Priority: $_selectedPriority/5',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                value: _selectedPriority.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) =>
                    setState(() => _selectedPriority = value.toInt()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Text('Dates', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedStartDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() => _selectedStartDate = date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedStartDate == null
                        ? 'Start Date'
                        : 'Start: ${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedTargetDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() => _selectedTargetDate = date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedTargetDate == null
                        ? 'Target Date'
                        : 'Target: ${_selectedTargetDate!.day}/${_selectedTargetDate!.month}/${_selectedTargetDate!.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Links', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ElevatedButton.icon(
              onPressed: _addLink,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_editingLinks.isEmpty)
          Text('No links yet',
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _editingLinks.length,
            itemBuilder: (context, index) {
              final link = _editingLinks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    _getLinkIcon(link.type),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(link.label ?? link.type,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 11)),
                          Text(link.url,
                              style: const TextStyle(fontSize: 9, color: Colors.blue),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _editingLinks.removeAt(index)),
                      child: Icon(Icons.delete_outline_rounded,
                          size: 16, color: Colors.red.withOpacity(0.7)),
                    ),
                  ],
                ),
              );
            },
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tags', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ElevatedButton.icon(
              onPressed: _addTag,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_editingTags.isEmpty)
          Text('No tags yet',
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _editingTags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tag,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.amber)),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(() => _editingTags.remove(tag)),
                      child: const Icon(Icons.close_rounded,
                          size: 14, color: Colors.amber),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
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
                  fontSize: 16,
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
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _currentProject.progressPercent / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_currentProject.progressPercent}% Complete',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, bool isDark, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
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

class PremiumHubComplete extends StatefulWidget {
  const PremiumHubComplete({super.key});

  @override
  State<PremiumHubComplete> createState() => _PremiumHubCompleteState();
}

class _PremiumHubCompleteState extends State<PremiumHubComplete>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _projectNameController.dispose();
    _projectDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.orange,
                indicatorWeight: 3,
                labelColor: Colors.orange,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                tabs: const [Tab(text: 'Habits'), Tab(text: 'Goals'), Tab(text: 'Projects')],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [const HabitsTab(), const GoalsTab(), _buildProjectsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsTab() {
    return ProjectsTabWithFilter();
  }
}

class ProjectsTabWithFilter extends StatefulWidget {
  const ProjectsTabWithFilter({super.key});

  @override
  State<ProjectsTabWithFilter> createState() => _ProjectsTabWithFilterState();
}

class _ProjectsTabWithFilterState extends State<ProjectsTabWithFilter> {
  String _filter = 'In Progress'; // 'In Progress', 'Overdue', 'Completed', 'All'

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final allProjects = appState.projects;
        final inProgressProjects = allProjects.where((p) => p.status == 1).toList();
        final completedProjects = allProjects.where((p) => p.status == 2).toList();
        final now = DateTime.now();
        final overdueProjects = allProjects.where((p) => 
          p.status == 1 && 
          p.targetDate != null && 
          p.targetDate!.isBefore(now)
        ).toList();
        
        // Filter projects based on selection
        final displayProjects = _filter == 'In Progress' 
            ? inProgressProjects 
            : _filter == 'Overdue'
                ? overdueProjects
                : _filter == 'Completed' 
                    ? completedProjects 
                    : allProjects;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Professional Header with Stats
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.purple, Colors.purple.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
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
                              Text('Project Manager', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text('${allProjects.length}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                              Text('Total Projects', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                            ],
                          ),
                          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.folder_rounded, color: Colors.white, size: 32)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildProjectStatBox('Active', '${inProgressProjects.length}', Colors.white.withOpacity(0.2))),
                          const SizedBox(width: 8),
                          Expanded(child: _buildProjectStatBox('Overdue', '${overdueProjects.length}', Colors.white.withOpacity(0.2))),
                          const SizedBox(width: 8),
                          Expanded(child: _buildProjectStatBox('Done', '${completedProjects.length}', Colors.white.withOpacity(0.2))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('In Progress', inProgressProjects.length, Icons.play_circle_outline_rounded, Colors.orange, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Overdue', overdueProjects.length, Icons.warning_amber_rounded, Colors.red, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Completed', completedProjects.length, Icons.check_circle_outline_rounded, Colors.green, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('All', allProjects.length, Icons.folder_rounded, Colors.purple, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddProjectDialog(context),
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    label: const Text('Add New Project', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Projects List
                if (displayProjects.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.folder_open_rounded, size: 48, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                          const SizedBox(height: 12),
                          Text('No ${_filter.toLowerCase()} projects', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayProjects.length,
                    itemBuilder: (context, index) => _buildProjectCard(displayProjects[index], isDark, appState),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, int count, IconData icon, Color color, bool isDark) {
    final isSelected = _filter == label;
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.3) : color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectStatBox(String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    // Call the parent widget's method
    context.findAncestorStateOfType<_PremiumHubCompleteState>()?._showAddProjectDialog(context);
  }

  Widget _buildProjectCard(Project project, bool isDark, AppState appState) {
    // Call the parent widget's method
    return context.findAncestorStateOfType<_PremiumHubCompleteState>()?._buildProjectCard(project, isDark, appState) ?? const SizedBox();
  }
}

// _PremiumHubCompleteState methods continuation
extension on _PremiumHubCompleteState {
  void _showAddProjectDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final categoryController = TextEditingController();
    final ownerController = TextEditingController();
    int selectedPriority = 1;
    DateTime? selectedTargetDate;
    final List<ProjectLink> links = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Project'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Project name',
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Project description',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Work, Personal, Learning',
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ownerController,
                  decoration: const InputDecoration(
                    hintText: 'Project owner/lead',
                    labelText: 'Owner',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text('Priority: $selectedPriority/5',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Slider(
                        value: selectedPriority.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: (value) =>
                            setState(() => selectedPriority = value.toInt()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() => selectedTargetDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedTargetDate == null
                                ? 'Target Date (Optional)'
                                : 'Target: ${selectedTargetDate!.day}/${selectedTargetDate!.month}/${selectedTargetDate!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Project Links (Optional)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                if (links.isNotEmpty)
                  Column(
                    children: links
                        .asMap()
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${entry.value.type}: ${entry.value.label ?? entry.value.url}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => links.removeAt(entry.key));
                                    },
                                    child: Icon(Icons.close_rounded,
                                        size: 16,
                                        color: Colors.red.withOpacity(0.7)),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddLinkDialog(context, links, setState),
                    icon: const Icon(Icons.link_rounded, size: 16),
                    label: const Text('Add Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
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
                if (titleController.text.isNotEmpty) {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  final newProject = Project(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    category: categoryController.text.isEmpty
                        ? null
                        : categoryController.text,
                    owner: ownerController.text.isEmpty
                        ? null
                        : ownerController.text,
                    priority: selectedPriority,
                    targetDate: selectedTargetDate,
                    links: links.isEmpty ? null : links,
                    status: 1,  // Changed from 0 to 1 - new projects are "In Progress" by default
                    progressPercent: 0,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  appState.addProject(newProject);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Project', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLinkDialog(BuildContext context, List<ProjectLink> links,
      StateSetter setState) {
    final urlController = TextEditingController();
    final labelController = TextEditingController();
    String selectedType = 'web';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Add Project Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                onChanged: (value) =>
                    setModalState(() => selectedType = value ?? 'web'),
                items: ['github', 'linkedin', 'web', 'figma', 'notion', 'other']
                    .map((t) => DropdownMenuItem(
                        value: t,
                        child: Row(
                          children: [
                            _getLinkIcon(t),
                            const SizedBox(width: 8),
                            Text(t),
                          ],
                        )))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Link Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  hintText: 'https://example.com',
                  labelText: 'URL *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  hintText: 'Optional label',
                  labelText: 'Label',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (urlController.text.isNotEmpty) {
                  final link = ProjectLink(
                    type: selectedType,
                    url: urlController.text,
                    label: labelController.text.isEmpty
                        ? null
                        : labelController.text,
                  );
                  setState(() => links.add(link));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
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

  Widget _buildViewerSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildViewerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontSize: 11), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  void _showProjectViewer(BuildContext context, Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(project: project),
      ),
    );
  }

  void _showProjectViewerDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.folder_rounded, color: Colors.purple),
            const SizedBox(width: 12),
            Expanded(child: Text(project.title)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildViewerSection('Progress', [
                _buildViewerRow('Current Progress', '${project.progressPercent}%'),
                _buildViewerRow('Status', project.status == 0 ? 'Not Started' : (project.status == 1 ? 'In Progress' : 'Completed')),
                if (project.tasksCompleted > 0 || project.totalTasks > 0) _buildViewerRow('Tasks', '${project.tasksCompleted}/${project.totalTasks}'),
              ]),
              const SizedBox(height: 16),
              _buildViewerSection('Details', [
                if (project.description != null) _buildViewerRow('Description', project.description!),
                if (project.category != null) _buildViewerRow('Category', project.category!),
                _buildViewerRow('Priority', 'P${project.priority}'),
                if (project.owner != null) _buildViewerRow('Owner', project.owner!),
              ]),
              if (project.startDate != null || project.targetDate != null) ...[
                const SizedBox(height: 16),
                _buildViewerSection('Timeline', [
                  if (project.startDate != null) _buildViewerRow('Start Date', '${project.startDate!.day}/${project.startDate!.month}/${project.startDate!.year}'),
                  if (project.targetDate != null) _buildViewerRow('Target Date', '${project.targetDate!.day}/${project.targetDate!.month}/${project.targetDate!.year}'),
                ]),
              ],
              if (project.links != null && project.links!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildViewerSection('Links', [
                  Wrap(
                    spacing: 8,
                    children: project.links!.map((link) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getLinkIcon(link.type),
                            const SizedBox(width: 6),
                            Text(link.label ?? link.type, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ]),
              ],
              if (project.tags != null && project.tags!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildViewerSection('Tags', [
                  Wrap(
                    spacing: 6,
                    children: project.tags!.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.amber)),
                      );
                    }).toList(),
                  ),
                ]),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUpdateProjectProgressDialog(Project project) {
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
                Text(
                  'Project Progress',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
                  maxLines: 2,
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
                final appState =
                    Provider.of<AppState>(context, listen: false);
                final newProgress = ProjectProgress(
                  id: DateTime.now().toString(),
                  projectId: project.id,
                  progressPercent: sliderValue,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
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
                  const SnackBar(
                    content: Text('Progress updated successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update Progress', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project, bool isDark, AppState appState) {
    final categoryColors = {'Work': Colors.purple, 'Personal': Colors.blue, 'Learning': Colors.green, 'Creative': Colors.orange};
    final color = categoryColors[project.category] ?? Colors.purple;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectDetailScreen(project: project),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.work_rounded, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                project.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? const Color(0xFFF1F5F9)
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            if (project.priority > 1)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: project.priority >= 3
                                      ? Colors.red.withOpacity(0.15)
                                      : Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'P${project.priority}',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: project.priority >= 3
                                        ? Colors.red
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                project.category ?? 'Work',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                            if (project.tasksCompleted != null && project.totalTasks != null) ...[
                              const SizedBox(width: 6),
                              Text(
                                '${project.tasksCompleted}/${project.totalTasks} tasks',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _showProjectEditor(context, project),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: Colors.blue.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => _showDeleteConfirmation(
                          context,
                          'Delete Project',
                          'Are you sure you want to delete "${project.title}"? This action cannot be undone.',
                          () => appState.deleteProject(project.id),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: Colors.red.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: project.progressPercent / 100,
                  minHeight: 6,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: project.status == 0
                          ? Colors.blue.withOpacity(0.15)
                          : (project.status == 1
                              ? Colors.orange.withOpacity(0.15)
                              : Colors.green.withOpacity(0.15)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      project.status == 0
                          ? 'Not Started'
                          : (project.status == 1 ? 'In Progress' : 'Completed'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: project.status == 0
                            ? Colors.blue
                            : (project.status == 1 ? Colors.orange : Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${project.progressPercent}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showUpdateProjectProgressDialog(project),
                  icon: const Icon(Icons.trending_up_rounded, size: 14, color: Colors.white),
                  label: const Text('Update Progress', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProjectEditor(BuildContext context, Project project) {
    final titleController = TextEditingController(text: project.title);
    final descController = TextEditingController(text: project.description ?? '');
    final ownerController = TextEditingController(text: project.owner ?? '');
    final notesController = TextEditingController(text: project.notes ?? '');
    String selectedCategory = project.category ?? 'Work';
    int selectedPriority = project.priority;
    DateTime? selectedStartDate = project.startDate;
    DateTime? selectedTargetDate = project.targetDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Project'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Project title',
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Project description',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ownerController,
                  decoration: const InputDecoration(
                    hintText: 'Project owner/lead',
                    labelText: 'Owner',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (value) =>
                      setState(() => selectedCategory = value ?? 'Work'),
                  items: ['Work', 'Personal', 'Learning', 'Creative']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text('Priority: $selectedPriority/5',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Slider(
                        value: selectedPriority.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: (value) =>
                            setState(() => selectedPriority = value.toInt()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedStartDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() => selectedStartDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedStartDate == null
                                ? 'Start Date (Optional)'
                                : 'Start: ${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedTargetDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() => selectedTargetDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedTargetDate == null
                                ? 'Target Date (Optional)'
                                : 'Target: ${selectedTargetDate!.day}/${selectedTargetDate!.month}/${selectedTargetDate!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Add any notes...',
                    labelText: 'Notes',
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
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  final updatedProject = project.copyWith(
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    owner: ownerController.text.isEmpty
                        ? null
                        : ownerController.text,
                    category: selectedCategory,
                    priority: selectedPriority,
                    startDate: selectedStartDate,
                    targetDate: selectedTargetDate,
                    notes: notesController.text.isEmpty
                        ? null
                        : notesController.text,
                    updatedAt: DateTime.now(),
                  );
                  appState.updateProject(updatedProject);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update Project', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitsTab extends StatefulWidget {
  const HabitsTab({super.key});

  @override
  State<HabitsTab> createState() => _HabitsTabState();
}

class _HabitsTabState extends State<HabitsTab> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final habits = appState.habits;
        final totalStreak = habits.fold<int>(0, (sum, h) => sum + h.streakCurrent);
        final longestStreak = habits.isEmpty ? 0 : habits.map((h) => h.streakLongest).reduce((a, b) => a > b ? a : b);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.orange, Colors.orange.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
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
                              Text('Habit Tracker', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text('${habits.length}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                              Text('Active Habits', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                            ],
                          ),
                          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 32)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildStatBox('Total Streak', '$totalStreak', Colors.white.withOpacity(0.2))),
                          const SizedBox(width: 10),
                          Expanded(child: _buildStatBox('Best Streak', '$longestStreak', Colors.white.withOpacity(0.2))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddHabitDialog(context),
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    label: const Text('Add New Habit', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
                const SizedBox(height: 20),
                if (habits.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.local_fire_department_rounded, size: 48, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                          const SizedBox(height: 12),
                          Text('No habits yet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: habits.length,
                    itemBuilder: (context, index) => _buildHabitCard(habits[index], isDark, context),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBox(String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildHabitCard(Habit habit, bool isDark, BuildContext context) {
    final streakPercentage = (habit.streakCurrent / (habit.streakLongest + 1)) * 100;
    final isCheckedInToday = habit.lastCheckIn != null &&
        habit.lastCheckIn!.year == DateTime.now().year &&
        habit.lastCheckIn!.month == DateTime.now().month &&
        habit.lastCheckIn!.day == DateTime.now().day;
    final lastCheckInText = habit.lastCheckIn != null
        ? 'Last: ${habit.lastCheckIn!.day}/${habit.lastCheckIn!.month}'
        : 'Never';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCheckedInToday
              ? Colors.orange
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: isCheckedInToday ? 2 : 1,
        ),
        boxShadow: isCheckedInToday
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              habit.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          if (habit.priority > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: habit.priority >= 3
                                    ? Colors.red.withOpacity(0.15)
                                    : Colors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'P${habit.priority}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: habit.priority >= 3
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            habit.frequency ?? 'daily',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          if (habit.category != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                habit.category!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                      if (habit.description != null &&
                          habit.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          habit.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _showEditHabitDialog(context, habit),
                      child: Icon(
                        Icons.edit_rounded,
                        size: 18,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        final appState =
                            Provider.of<AppState>(context, listen: false);
                        _showDeleteConfirmation(
                          context,
                          'Delete Habit',
                          'Are you sure you want to delete "${habit.title}"? This action cannot be undone.',
                          () => appState.deleteHabit(habit.id),
                        );
                      },
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.red.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: streakPercentage / 100,
                minHeight: 6,
                backgroundColor: Colors.orange.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      'Streak: ${habit.streakCurrent}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Best: ${habit.streakLongest}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 12,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Total: ${habit.totalCheckIns}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                Text(
                  lastCheckInText,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  final updated = habit.copyWith(
                    streakCurrent: isCheckedInToday
                        ? habit.streakCurrent
                        : habit.streakCurrent + 1,
                    streakLongest: isCheckedInToday
                        ? habit.streakLongest
                        : (habit.streakCurrent + 1 > habit.streakLongest
                            ? habit.streakCurrent + 1
                            : habit.streakLongest),
                    lastCheckIn: DateTime.now(),
                    totalCheckIns: habit.totalCheckIns + 1,
                    updatedAt: DateTime.now(),
                  );
                  appState.updateHabit(updated);
                },
                icon: Icon(
                  isCheckedInToday
                      ? Icons.check_rounded
                      : Icons.add_circle_outline_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  isCheckedInToday ? 'Checked In Today ✓' : 'Check In',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isCheckedInToday ? Colors.green : Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final notesController = TextEditingController();
    String selectedFrequency = 'daily';
    String selectedCategory = 'Health';
    int selectedPriority = 1;
    DateTime? selectedTargetDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Habit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Habit Title
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Habit name',
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // Description
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Why do you want this habit?',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // Frequency
                DropdownButtonFormField<String>(
                  value: selectedFrequency,
                  onChanged: (value) =>
                      setState(() => selectedFrequency = value ?? 'daily'),
                  items: ['daily', 'weekly', 'monthly']
                      .map((f) => DropdownMenuItem(
                          value: f, child: Text(f.toUpperCase())))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // Category
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (value) =>
                      setState(() => selectedCategory = value ?? 'Health'),
                  items: ['Health', 'Productivity', 'Learning', 'Fitness', 'Finance', 'Personal']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // Priority
                Row(
                  children: [
                    Expanded(
                      child: Text('Priority: $selectedPriority/5',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Slider(
                        value: selectedPriority.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: (value) =>
                            setState(() => selectedPriority = value.toInt()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Target Date
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() => selectedTargetDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedTargetDate == null
                                ? 'Target Date (Optional)'
                                : 'Target: ${selectedTargetDate!.day}/${selectedTargetDate!.month}/${selectedTargetDate!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Notes
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Add any notes...',
                    labelText: 'Notes',
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
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  final newHabit = Habit(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    frequency: selectedFrequency,
                    targetCount: 1,
                    streakCurrent: 0,
                    streakLongest: 0,
                    category: selectedCategory,
                    priority: selectedPriority,
                    notes: notesController.text.isEmpty
                        ? null
                        : notesController.text,
                    targetDate: selectedTargetDate,
                    isActive: true,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  appState.addHabit(newHabit);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Habit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditHabitDialog(BuildContext context, Habit habit) {
    final titleController = TextEditingController(text: habit.title);
    final descController = TextEditingController(text: habit.description ?? '');
    final notesController = TextEditingController(text: habit.notes ?? '');
    String selectedFrequency = habit.frequency ?? 'daily';
    String selectedCategory = habit.category ?? 'Health';
    int selectedPriority = habit.priority;
    DateTime? selectedTargetDate = habit.targetDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Habit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Habit name',
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Why do you want this habit?',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedFrequency,
                  onChanged: (value) =>
                      setState(() => selectedFrequency = value ?? 'daily'),
                  items: ['daily', 'weekly', 'monthly']
                      .map((f) => DropdownMenuItem(
                          value: f, child: Text(f.toUpperCase())))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (value) =>
                      setState(() => selectedCategory = value ?? 'Health'),
                  items: ['Health', 'Productivity', 'Learning', 'Fitness', 'Finance', 'Personal']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text('Priority: $selectedPriority/5',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Slider(
                        value: selectedPriority.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: (value) =>
                            setState(() => selectedPriority = value.toInt()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedTargetDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() => selectedTargetDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedTargetDate == null
                                ? 'Target Date (Optional)'
                                : 'Target: ${selectedTargetDate!.day}/${selectedTargetDate!.month}/${selectedTargetDate!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Add any notes...',
                    labelText: 'Notes',
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
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  final updatedHabit = habit.copyWith(
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    frequency: selectedFrequency,
                    category: selectedCategory,
                    priority: selectedPriority,
                    notes: notesController.text.isEmpty
                        ? null
                        : notesController.text,
                    targetDate: selectedTargetDate,
                    updatedAt: DateTime.now(),
                  );
                  appState.updateHabit(updatedHabit);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update Habit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalsTab extends StatefulWidget {
  const GoalsTab({super.key});

  @override
  State<GoalsTab> createState() => _GoalsTabState();
}

class _GoalsTabState extends State<GoalsTab> {
  String _filter = 'In Progress'; // 'In Progress', 'Completed', 'All'

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final allGoals = appState.goals;
        final inProgressGoals = allGoals.where((g) => g.status == 1).toList();
        final completedGoals = allGoals.where((g) => g.status == 2).toList();
        
        // Filter goals based on selection
        final displayGoals = _filter == 'In Progress' 
            ? inProgressGoals 
            : _filter == 'Completed' 
                ? completedGoals 
                : allGoals;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.pink, Colors.pink.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Goals Overview', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGoalStat('In Progress', inProgressGoals.length.toString(), Colors.white.withOpacity(0.2)),
                          _buildGoalStat('Completed', completedGoals.length.toString(), Colors.white.withOpacity(0.2)),
                          _buildGoalStat('Total', allGoals.length.toString(), Colors.white.withOpacity(0.2)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('In Progress', inProgressGoals.length, Icons.play_circle_outline_rounded, Colors.orange, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Completed', completedGoals.length, Icons.check_circle_outline_rounded, Colors.green, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('All', allGoals.length, Icons.flag_rounded, Colors.pink, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddGoalDialog(context),
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    label: const Text('Add New Goal', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
                const SizedBox(height: 20),
                
                if (displayGoals.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.flag_rounded, size: 48, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                          const SizedBox(height: 12),
                          Text('No ${_filter.toLowerCase()} goals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayGoals.length,
                    itemBuilder: (context, index) => _buildGoalCard(displayGoals[index], isDark, context),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, int count, IconData icon, Color color, bool isDark) {
    final isSelected = _filter == label;
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.3) : color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalStat(String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildGoalCard(Goal goal, bool isDark, BuildContext context) {
    final categoryColors = {'personal': Colors.purple, 'career': Colors.blue, 'health': Colors.green, 'finance': Colors.amber};
    final color = categoryColors[goal.category] ?? Colors.purple;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoalDetailScreen(goal: goal),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.flag_rounded, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              goal.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          if (goal.priority > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: goal.priority >= 3
                                    ? Colors.red.withOpacity(0.15)
                                    : Colors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'P${goal.priority}',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: goal.priority >= 3
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              goal.category ?? 'personal',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ),
                          if (goal.unit != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${goal.currentValue}/${goal.targetValue} ${goal.unit}',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _showEditGoalDialog(context, goal),
                      child: Icon(
                        Icons.edit_rounded,
                        size: 18,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        final appState =
                            Provider.of<AppState>(context, listen: false);
                        _showDeleteConfirmation(
                          context,
                          'Delete Goal',
                          'Are you sure you want to delete "${goal.title}"? This action cannot be undone.',
                          () => appState.deleteGoal(goal.id),
                        );
                      },
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.red.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: goal.progressPercent / 100,
                minHeight: 6,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.progressPercent}% Complete',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                if (goal.targetDate != null)
                  Text(
                    'Due: ${goal.targetDate!.day}/${goal.targetDate!.month}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
              ],
            ),
            if (goal.reason != null || goal.strategy != null) ...[
              const SizedBox(height: 10),
              if (goal.reason != null)
                Text(
                  'Why: ${goal.reason!}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              if (goal.strategy != null)
                Text(
                  'How: ${goal.strategy!}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showUpdateGoalProgressDialog(goal),
                icon: const Icon(Icons.trending_up_rounded, size: 14, color: Colors.white),
                label: const Text('Update Progress', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUpdateGoalProgressDialog(Goal goal) {
    double sliderValue = goal.currentValue.toDouble();
    final notesController = TextEditingController();
    final maxValue = goal.targetValue ?? 100.0;

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
              onPressed: () async {
                final appState =
                    Provider.of<AppState>(context, listen: false);
                final newProgress = GoalProgress(
                  id: DateTime.now().toString(),
                  goalId: goal.id,
                  value: sliderValue,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                  recordedAt: DateTime.now(),
                );
                final updatedHistory = [...?goal.progressHistory, newProgress];
                final newProgressPercent =
                    goal.targetValue != null && goal.targetValue! > 0
                        ? ((sliderValue / goal.targetValue!) * 100).toInt()
                        : 0;
                final updated = goal.copyWith(
                  currentValue: sliderValue,
                  progressPercent: newProgressPercent.clamp(0, 100),
                  progressHistory: updatedHistory,
                  updatedAt: DateTime.now(),
                );
                await appState.updateGoal(updated);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress updated successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
              child: const Text('Update Progress', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final reasonController = TextEditingController();
    final strategyController = TextEditingController();
    final targetValueController = TextEditingController();
    final unitController = TextEditingController();
    String selectedCategory = 'personal';
    int selectedPriority = 1;
    DateTime? selectedTargetDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Goal title',
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Goal description',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (value) =>
                      setState(() => selectedCategory = value ?? 'personal'),
                  items: ['personal', 'career', 'health', 'finance']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text('Priority: $selectedPriority/5',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Slider(
                        value: selectedPriority.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: (value) =>
                            setState(() => selectedPriority = value.toInt()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: targetValueController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '100',
                          labelText: 'Target Value',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: unitController,
                        decoration: const InputDecoration(
                          hintText: 'kg, miles, dollars',
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() => selectedTargetDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedTargetDate == null
                                ? 'Target Date (Optional)'
                                : 'Target: ${selectedTargetDate!.day}/${selectedTargetDate!.month}/${selectedTargetDate!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Why is this goal important?',
                    labelText: 'Reason',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: strategyController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'How will you achieve it?',
                    labelText: 'Strategy',
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
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  final newGoal = Goal(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    category: selectedCategory,
                    targetValue: targetValueController.text.isEmpty
                        ? null
                        : double.tryParse(targetValueController.text),
                    unit: unitController.text.isEmpty ? null : unitController.text,
                    targetDate: selectedTargetDate,
                    priority: selectedPriority,
                    reason: reasonController.text.isEmpty
                        ? null
                        : reasonController.text,
                    strategy: strategyController.text.isEmpty
                        ? null
                        : strategyController.text,
                    status: 1,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  appState.addGoal(newGoal);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
              child: const Text('Create Goal', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, Goal goal) {
    final titleController = TextEditingController(text: goal.title);
    final descController = TextEditingController(text: goal.description ?? '');
    final reasonController = TextEditingController(text: goal.reason ?? '');
    final strategyController = TextEditingController(text: goal.strategy ?? '');
    final targetValueController = TextEditingController(text: goal.targetValue?.toString() ?? '');
    final unitController = TextEditingController(text: goal.unit ?? '');
    String selectedCategory = goal.category ?? 'personal';
    int selectedPriority = goal.priority;
    DateTime? selectedTargetDate = goal.targetDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Goal title',
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Goal description',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (value) =>
                      setState(() => selectedCategory = value ?? 'personal'),
                  items: ['personal', 'career', 'health', 'finance']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text('Priority: $selectedPriority/5',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Slider(
                        value: selectedPriority.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: (value) =>
                            setState(() => selectedPriority = value.toInt()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: targetValueController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '100',
                          labelText: 'Target Value',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: unitController,
                        decoration: const InputDecoration(
                          hintText: 'kg, miles, dollars',
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedTargetDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() => selectedTargetDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedTargetDate == null
                                ? 'Target Date (Optional)'
                                : 'Target: ${selectedTargetDate!.day}/${selectedTargetDate!.month}/${selectedTargetDate!.year}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Why is this goal important?',
                    labelText: 'Reason',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: strategyController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'How will you achieve it?',
                    labelText: 'Strategy',
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
                if (titleController.text.isNotEmpty) {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  final updatedGoal = goal.copyWith(
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    category: selectedCategory,
                    targetValue: targetValueController.text.isEmpty
                        ? null
                        : double.tryParse(targetValueController.text),
                    unit: unitController.text.isEmpty ? null : unitController.text,
                    targetDate: selectedTargetDate,
                    priority: selectedPriority,
                    reason: reasonController.text.isEmpty
                        ? null
                        : reasonController.text,
                    strategy: strategyController.text.isEmpty
                        ? null
                        : strategyController.text,
                    updatedAt: DateTime.now(),
                  );
                  await appState.updateGoal(updatedGoal);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
              child: const Text('Update Goal', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateProgressDialog(BuildContext context, Goal goal) {
    int sliderValue = goal.progressPercent;
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Update Goal Progress'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Goal Progress',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
                            '$sliderValue%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.pink,
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
                          backgroundColor: Colors.pink.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.pink),
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
                  maxLines: 2,
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
                final appState =
                    Provider.of<AppState>(context, listen: false);
                final newProgress = GoalProgress(
                  id: DateTime.now().toString(),
                  goalId: goal.id,
                  value: sliderValue.toDouble(),
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                  recordedAt: DateTime.now(),
                );
                final updatedHistory = [...?goal.progressHistory, newProgress];
                final updated = goal.copyWith(
                  progressPercent: sliderValue,
                  status: sliderValue >= 100 ? 2 : 1,
                  progressHistory: updatedHistory,
                  updatedAt: DateTime.now(),
                );
                await appState.updateGoal(updated);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
              child: const Text('Update Progress', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewerSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildViewerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontSize: 11), textAlign: TextAlign.end),
          ),
        ],
      ),
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
