import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_state.dart';
import '../../core/models/todo.dart';
import '../../core/models/task.dart';
import '../../core/utils/responsive.dart';

class PremiumWorkComplete extends StatefulWidget {
  const PremiumWorkComplete({super.key});

  @override
  State<PremiumWorkComplete> createState() => _PremiumWorkCompleteState();
}

class _PremiumWorkCompleteState extends State<PremiumWorkComplete>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();
  DateTime? _selectedDueDate;
  int _selectedPriority = 1;
  String _taskFilter = 'pending'; // pending, completed, overdue

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskTitleController.dispose();
    _taskDescController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Responsive().init(context);

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
                indicatorColor: Colors.teal,
                indicatorWeight: 3,
                labelColor: Colors.teal,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                tabs: const [Tab(text: 'Tasks'), Tab(text: 'Todos')],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTasksTab(), _buildTodosTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final tasks = appState.tasks;
        final completedTasks = tasks.where((t) => t.status == 1).length;
        final activeTasks = tasks.where((t) => t.status == 0).length;
        final overdueTasks = tasks
            .where((t) =>
                t.status == 0 &&
                t.dueDate != null &&
                t.dueDate!.isBefore(DateTime.now()))
            .length;

        // Filter tasks based on selected filter
        List<Task> filteredTasks;
        if (_taskFilter == 'pending') {
          filteredTasks = tasks.where((t) => t.status == 0).toList();
        } else if (_taskFilter == 'completed') {
          filteredTasks = tasks.where((t) => t.status == 1).toList();
        } else if (_taskFilter == 'overdue') {
          filteredTasks = tasks
              .where((t) =>
                  t.status == 0 &&
                  t.dueDate != null &&
                  t.dueDate!.isBefore(DateTime.now()))
              .toList();
        } else {
          filteredTasks = tasks;
        }

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
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.teal.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
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
                                'Task Manager',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${tasks.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Total Tasks',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.task_alt_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTaskStatBox(
                              'Pending',
                              '$activeTasks',
                              Colors.white.withOpacity(0.2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTaskStatBox(
                              'Completed',
                              '$completedTasks',
                              Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Add Task Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddTaskDialog(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add New Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterPill('Pending', 'pending', activeTasks, isDark),
                      const SizedBox(width: 8),
                      _buildFilterPill('Overdue', 'overdue', overdueTasks, isDark),
                      const SizedBox(width: 8),
                      _buildFilterPill('Completed', 'completed', completedTasks, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Tasks List
                if (filteredTasks.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 48,
                            color: isDark
                                ? const Color(0xFF475569)
                                : const Color(0xFFCBD5E1),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _taskFilter == 'completed'
                                ? 'No completed tasks yet'
                                : _taskFilter == 'overdue'
                                    ? 'No overdue tasks'
                                    : 'No pending tasks',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) =>
                        _buildTaskCard(filteredTasks[index], isDark, appState),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterPill(
      String label, String value, int count, bool isDark) {
    final isActive = _taskFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _taskFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.teal : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.teal : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.white.withOpacity(0.3) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isActive ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatBox(String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, bool isDark, AppState appState) {
    final isCompleted = task.status == 1;
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !isCompleted;
    final priorityColor = _getPriorityColor(task.priority);
    final priorityLabel = _getPriorityLabel(task.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  final updated = Task(
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    priority: task.priority,
                    status: task.status == 0 ? 1 : 0,
                    dueDate: task.dueDate,
                    createdAt: task.createdAt,
                    updatedAt: DateTime.now(),
                  );
                  appState.updateTask(updated);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.teal,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: isCompleted ? Colors.teal : Colors.transparent,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check_rounded,
                          size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFFF1F5F9)
                            : const Color(0xFF0F172A),
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => appState.deleteTask(task.id),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: Colors.red.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (task.dueDate != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? Colors.red.withOpacity(0.15)
                        : Colors.teal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: isOverdue ? Colors.red : Colors.teal,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d').format(task.dueDate!),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isOverdue ? Colors.red : Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priorityLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Normal';
    }
  }

  Widget _buildTodosTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // Filter only active todos (status == 0)
        final activeTodos = appState.todos.where((t) => t.status == 0).toList();
        final completedCount = appState.todos.where((t) => t.status == 1).length;

        return Column(
          children: [
            // Header with stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Todos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        '${activeTodos.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  if (completedCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$completedCount completed ✓',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Add todo input
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Add a new todo...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_todoController.text.isNotEmpty) {
                        final newTodo = Todo(
                          id: DateTime.now().toString(),
                          title: _todoController.text,
                          category: 'Work',
                          priority: 1,
                          status: 0,
                          dueDate: DateTime.now(),
                          createdAt: DateTime.now(),
                          completedAt: null,
                        );
                        appState.addTodo(newTodo);
                        _todoController.clear();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            // Todos list
            Expanded(
              child: activeTodos.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 48,
                              color: Colors.green.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'All todos completed! 🎉',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            if (completedCount > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                'You have $completedCount completed todos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: activeTodos.length,
                      itemBuilder: (context, index) =>
                          _buildTodoCard(activeTodos[index], isDark, appState),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoCard(Todo todo, bool isDark, AppState appState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              final updated = Todo(
                id: todo.id,
                title: todo.title,
                category: todo.category,
                priority: todo.priority,
                status: 1,
                dueDate: todo.dueDate,
                createdAt: todo.createdAt,
                completedAt: DateTime.now(),
              );
              appState.updateTodo(updated);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.teal,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.teal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF0F172A),
                  ),
                ),
                if (todo.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d').format(todo.dueDate!),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => appState.deleteTodo(todo.id),
            child: Icon(
              Icons.delete_outline_rounded,
              size: 18,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    _selectedDueDate = null;
    _selectedPriority = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskTitleController,
                  decoration: const InputDecoration(
                    hintText: 'Task title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _taskDescController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDueDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setDialogState(() => _selectedDueDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedDueDate == null
                                      ? 'Due date'
                                      : DateFormat('MMM d').format(_selectedDueDate!),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<int>(
                      value: _selectedPriority,
                      onChanged: (val) =>
                          setDialogState(() => _selectedPriority = val ?? 1),
                      items: [
                        DropdownMenuItem(value: 1, child: const Text('Low')),
                        DropdownMenuItem(value: 2, child: const Text('Med')),
                        DropdownMenuItem(value: 3, child: const Text('High')),
                      ],
                    ),
                  ],
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
                if (_taskTitleController.text.isNotEmpty) {
                  final appState =
                      Provider.of<AppState>(context, listen: false);
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    title: _taskTitleController.text,
                    description: _taskDescController.text,
                    priority: _selectedPriority,
                    status: 0,
                    dueDate: _selectedDueDate,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  appState.addTask(newTask);
                  _taskTitleController.clear();
                  _taskDescController.clear();
                  _selectedDueDate = null;
                  _selectedPriority = 1;
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
