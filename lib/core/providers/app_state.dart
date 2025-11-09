import 'package:flutter/foundation.dart';
import '../services/database_service.dart';
import '../models/task.dart';
import '../models/study_session.dart';
import '../models/project.dart';
import '../models/daily_log.dart';
import '../models/todo.dart';
import '../models/finance_entry.dart';
import '../models/budget.dart';
import '../models/habit.dart';
import '../models/goal.dart';
import '../models/note.dart';
import '../models/daily_reflection.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/validators.dart';

class AppState with ChangeNotifier {
  final DatabaseService _db;
  List<Task> _tasks = [];
  List<StudySession> _studySessions = [];
  List<Project> _projects = [];
  List<DailyLog> _dailyLogs = [];
  List<Todo> _todos = [];
  List<FinanceEntry> _financeEntries = [];
  List<Budget> _budgets = [];
  List<Habit> _habits = [];
  List<Goal> _goals = [];
  List<Note> _notes = [];
  List<DailyReflection> _reflections = [];
  bool _isLoading = false;
  String? _error;
  String? get error => _error;

  AppState(this._db) {
    _loadInitialData();
  }

  // Getters
  List<Task> get tasks => _tasks;
  List<StudySession> get studySessions => _studySessions;
  List<Project> get projects => _projects;
  List<DailyLog> get dailyLogs => _dailyLogs;
  List<Todo> get todos => _todos;
  List<FinanceEntry> get financeEntries => _financeEntries;
  List<Budget> get budgets => _budgets;
  List<Habit> get habits => _habits;
  List<Goal> get goals => _goals;
  List<Note> get notes => _notes;
  List<DailyReflection> get reflections => _reflections;
  bool get isLoading => _isLoading;

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        _loadTasks(),
        _loadProjects(),
        _loadDailyLogs(),
        _loadTodos(),
        _loadFinanceEntries(),
        _loadBudgets(),
        _loadHabits(),
        _loadGoals(),
        _loadNotes(),
        _loadReflections(),
      ]);
    } catch (e) {
      _error = 'Error loading initial data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadTasks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final results = await _db.getAll('tasks');
      _tasks = results.map((map) => Task.fromMap(map)).toList();
    } catch (e) {
      _error = 'Failed to load tasks: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadStudySessions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final results = await _db.getAll('study_sessions');
      _studySessions = results.map((map) => StudySession.fromMap(map)).toList();
    } catch (e) {
      _error = 'Failed to load study sessions: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProjects() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final results = await _db.getAll('projects');
      _projects = results.map((map) => Project.fromMap(map)).toList();
      debugPrint('Loaded ${_projects.length} projects from database');
      for (var project in _projects) {
        debugPrint('Project: ${project.title} (ID: ${project.id})');
      }
    } catch (e, st) {
      _error = 'Failed to load projects: $e';
      debugPrint(_error);
      debugPrint('Stack trace: $st');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Task operations
  Future<void> addTask(Task task) async {
    if (!Validators.isValidTitle(task.title)) {
      throw ValidationException('Invalid task title');
    }
    if (task.estimatedMinutes != null && !Validators.isValidDuration(task.estimatedMinutes)) {
      throw ValidationException('Invalid duration');
    }
    _tasks.add(task);
    notifyListeners();
    // Fire and forget - don't await
    _db.insert('tasks', task.toMap()).onError((e, st) {
      debugPrint('Error saving task: $e');
      return '';
    });
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners(); // Notify UI immediately
      debugPrint('Task updated: ${task.title}, status: ${task.status}');
      try {
        await _db.update('tasks', task.id, task.toMap());
        debugPrint('Task saved to database successfully');
      } catch (e, st) {
        debugPrint('Error updating task: $e');
        debugPrint('Stack trace: $st');
      }
    } else {
      debugPrint('Task not found for update: ${task.id}');
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
    _db.delete('tasks', taskId).onError((e, st) {
      debugPrint('Error deleting task: $e');
      return false;
    });
  }

  // Study session operations
  Future<void> addStudySession(StudySession session) async {
    _studySessions.add(session);
    notifyListeners();
    _db.insert('study_sessions', session.toMap()).onError((e, st) {
      debugPrint('Error saving study session: $e');
      debugPrint('Error saving study session: $e');
      return '';
    });
  }

  Future<void> updateStudySession(StudySession session) async {
    final index = _studySessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _studySessions[index] = session;
      notifyListeners();
    }
    _db.update('study_sessions', session.id, session.toMap()).onError((e, st) {
      debugPrint('Error updating study session: $e');
      debugPrint('Error updating study session: $e');
      return false;
    });
  }

  Future<void> deleteStudySession(String id) async {
    _studySessions.removeWhere((s) => s.id == id);
    notifyListeners();
    _db.delete('study_sessions', id).onError((e, st) {
      debugPrint('Error deleting study session: $e');
      return false;
    });
  }

  // Project operations
  Future<void> addProject(Project project) async {
    _projects.add(project);
    notifyListeners();
    debugPrint('Adding project: ${project.title} (ID: ${project.id})');
    try {
      await _db.insert('projects', project.toMap());
      debugPrint('Project saved to database successfully: ${project.title}');
    } catch (e, st) {
      debugPrint('Error saving project: $e');
      debugPrint('Stack trace: $st');
      // Remove from list if save failed
      _projects.removeWhere((p) => p.id == project.id);
      notifyListeners();
    }
  }

  Future<void> updateProject(Project project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
      debugPrint('Project updated: ${project.title} (ID: ${project.id})');
      try {
        await _db.update('projects', project.id, project.toMap());
        debugPrint('Project saved to database successfully');
      } catch (e, st) {
        debugPrint('Error updating project: $e');
        debugPrint('Stack trace: $st');
      }
    } else {
      debugPrint('Project not found for update: ${project.id}');
    }
  }

  Future<void> deleteProject(String projectId) async {
    debugPrint('Deleting project: $projectId');
    _projects.removeWhere((p) => p.id == projectId);
    notifyListeners();
    try {
      await _db.delete('projects', projectId);
      debugPrint('Project deleted from database successfully');
    } catch (e, st) {
      debugPrint('Error deleting project: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> refreshData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.wait([
        _loadTasks(),
        _loadProjects(),
        _loadDailyLogs(),
        _loadTodos(),
        _loadFinanceEntries(),
        _loadBudgets(),
        _loadHabits(),
        _loadGoals(),
        _loadNotes(),
        _loadReflections(),
      ]);
    } catch (e) {
      _error = 'Failed to refresh data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Daily logs operations
  Future<void> _loadDailyLogs() async {
    try {
      final data = await _db.getAll('daily_logs');
      _dailyLogs = data.map((map) => DailyLog.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load daily logs: $e';
      notifyListeners();
    }
  }

  Future<void> addDailyLog(DailyLog log) async {
    _dailyLogs.add(log);
    notifyListeners();
    try {
      await _db.insert('daily_logs', log.toMap());
    } catch (e, st) {
      debugPrint('Error saving daily log: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> updateDailyLog(DailyLog log) async {
    final index = _dailyLogs.indexWhere((l) => l.id == log.id);
    if (index != -1) {
      _dailyLogs[index] = log;
      notifyListeners();
    }
    try {
      await _db.update('daily_logs', log.id, log.toMap());
    } catch (e, st) {
      debugPrint('Error updating daily log: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> deleteDailyLog(String logId) async {
    _dailyLogs.removeWhere((l) => l.id == logId);
    notifyListeners();
    try {
      await _db.delete('daily_logs', logId);
    } catch (e, st) {
      debugPrint('Error deleting daily log: $e');
      debugPrint('Stack trace: $st');
    }
  }

  // Todos operations
  Future<void> _loadTodos() async {
    try {
      final data = await _db.getAll('todos');
      _todos = data.map((map) => Todo.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load todos: $e';
      notifyListeners();
    }
  }

  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    notifyListeners();
    _db.insert('todos', todo.toMap()).onError((e, st) {
      debugPrint('Error saving todo: $e');
      debugPrint('Error saving todo: $e');
      return '';
    });
  }

  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      notifyListeners();
    }
    _db.update('todos', todo.id, todo.toMap()).onError((e, st) {
      debugPrint('Error updating todo: $e');
      debugPrint('Error updating todo: $e');
      return false;
    });
  }

  Future<void> deleteTodo(String todoId) async {
    _todos.removeWhere((t) => t.id == todoId);
    notifyListeners();
    _db.delete('todos', todoId).onError((e, st) {
      debugPrint('Error deleting todo: $e');
      return false;
    });
  }

  // Finance operations
  Future<void> _loadFinanceEntries() async {
    try {
      final data = await _db.getAll('finance_entries');
      _financeEntries = data.map((map) => FinanceEntry.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load finance entries: $e';
      notifyListeners();
    }
  }

  Future<void> addFinanceEntry(FinanceEntry entry) async {
    _financeEntries.add(entry);
    notifyListeners();
    _db.insert('finance_entries', entry.toMap()).onError((e, st) {
      debugPrint('Error saving finance entry: $e');
      debugPrint('Error saving finance entry: $e');
      return '';
    });
  }

  Future<void> updateFinanceEntry(FinanceEntry entry) async {
    final index = _financeEntries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _financeEntries[index] = entry;
      notifyListeners();
    }
    _db.update('finance_entries', entry.id, entry.toMap()).onError((e, st) {
      debugPrint('Error updating finance entry: $e');
      debugPrint('Error updating finance entry: $e');
      return false;
    });
  }

  Future<void> deleteFinanceEntry(String id) async {
    _financeEntries.removeWhere((e) => e.id == id);
    notifyListeners();
    _db.delete('finance_entries', id).onError((e, st) {
      debugPrint('Error deleting finance entry: $e');
      return false;
    });
  }

  // Budget operations
  Future<void> _loadBudgets() async {
    try {
      final data = await _db.getAll('budgets');
      _budgets = data.map((map) => Budget.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load budgets: $e';
      notifyListeners();
    }
  }

  Future<void> addBudget(Budget budget) async {
    _budgets.add(budget);
    notifyListeners();
    _db.insert('budgets', budget.toMap()).onError((e, st) {
      debugPrint('Error saving budget: $e');
      debugPrint('Error saving budget: $e');
      return '';
    });
  }

  Future<void> updateBudget(Budget budget) async {
    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      _budgets[index] = budget;
      notifyListeners();
    }
    _db.update('budgets', budget.id, budget.toMap()).onError((e, st) {
      debugPrint('Error updating budget: $e');
      debugPrint('Error updating budget: $e');
      return false;
    });
  }

  Future<void> deleteBudget(String id) async {
    _budgets.removeWhere((b) => b.id == id);
    notifyListeners();
    _db.delete('budgets', id).onError((e, st) {
      debugPrint('Error deleting budget: $e');
      return false;
    });
  }

  // Habit operations
  Future<void> _loadHabits() async {
    try {
      final data = await _db.getAll('habits');
      _habits = data.map((map) => Habit.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load habits: $e';
      notifyListeners();
    }
  }

  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    notifyListeners();
    try {
      await _db.insert('habits', habit.toMap());
    } catch (e, st) {
      debugPrint('Error saving habit: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
    try {
      await _db.update('habits', habit.id, habit.toMap());
    } catch (e, st) {
      debugPrint('Error updating habit: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
    try {
      await _db.delete('habits', id);
    } catch (e, st) {
      debugPrint('Error deleting habit: $e');
      debugPrint('Stack trace: $st');
    }
  }

  // Goal operations
  Future<void> _loadGoals() async {
    try {
      final data = await _db.getAll('goals');
      _goals = data.map((map) => Goal.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load goals: $e';
      notifyListeners();
    }
  }

  Future<void> addGoal(Goal goal) async {
    _goals.add(goal);
    notifyListeners();
    try {
      await _db.insert('goals', goal.toMap());
    } catch (e, st) {
      debugPrint('Error saving goal: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
    try {
      await _db.update('goals', goal.id, goal.toMap());
    } catch (e, st) {
      debugPrint('Error updating goal: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
    try {
      await _db.delete('goals', id);
    } catch (e, st) {
      debugPrint('Error deleting goal: $e');
      debugPrint('Stack trace: $st');
    }
  }

  // Note operations
  Future<void> _loadNotes() async {
    try {
      final data = await _db.getAll('notes');
      _notes = data.map((map) => Note.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load notes: $e';
      notifyListeners();
    }
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    notifyListeners();
    _db.insert('notes', note.toMap()).onError((e, st) {
      debugPrint('Error saving note: $e');
      debugPrint('Error saving note: $e');
      return '';
    });
  }

  Future<void> updateNote(Note note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
    _db.update('notes', note.id, note.toMap()).onError((e, st) {
      debugPrint('Error updating note: $e');
      debugPrint('Error updating note: $e');
      return false;
    });
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    _db.delete('notes', id).onError((e, st) {
      debugPrint('Error deleting note: $e');
      return false;
    });
  }

  // Reflection operations
  Future<void> _loadReflections() async {
    try {
      final data = await _db.getAll('daily_reflections');
      _reflections = data.map((map) => DailyReflection.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load reflections: $e';
      notifyListeners();
    }
  }

  Future<void> addReflection(DailyReflection reflection) async {
    _reflections.add(reflection);
    notifyListeners();
    _db.insert('daily_reflections', reflection.toMap()).onError((e, st) {
      debugPrint('Error saving reflection: $e');
      debugPrint('Error saving reflection: $e');
      return '';
    });
  }

  Future<void> updateReflection(DailyReflection reflection) async {
    final index = _reflections.indexWhere((r) => r.id == reflection.id);
    if (index != -1) {
      _reflections[index] = reflection;
      notifyListeners();
    }
    _db.update('daily_reflections', reflection.id, reflection.toMap()).onError((e, st) {
      debugPrint('Error updating reflection: $e');
      debugPrint('Error updating reflection: $e');
      return false;
    });
  }

  Future<void> deleteReflection(String id) async {
    _reflections.removeWhere((r) => r.id == id);
    notifyListeners();
    _db.delete('daily_reflections', id).onError((e, st) {
      debugPrint('Error deleting reflection: $e');
      return false;
    });
  }
}
