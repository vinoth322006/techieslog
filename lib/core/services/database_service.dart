import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../exceptions/app_exceptions.dart';

class DatabaseService {
  static Database? _database;
  
  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'techlog.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        priority INTEGER DEFAULT 1,
        status INTEGER DEFAULT 0,
        estimated_minutes INTEGER,
        actual_minutes INTEGER DEFAULT 0,
        due_date DATETIME,
        project_id TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Study sessions table
    await db.execute('''
      CREATE TABLE study_sessions (
        id TEXT PRIMARY KEY,
        subject TEXT NOT NULL,
        topic TEXT,
        minutes INTEGER NOT NULL,
        comprehension_rating INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Projects table
    await db.execute('''
      CREATE TABLE projects (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        status INTEGER DEFAULT 0,
        progress_percent INTEGER DEFAULT 0,
        category TEXT,
        notes TEXT,
        priority INTEGER DEFAULT 1,
        start_date DATETIME,
        target_date DATETIME,
        tasks_completed INTEGER DEFAULT 0,
        total_tasks INTEGER DEFAULT 0,
        owner TEXT,
        tags TEXT,
        links TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Milestones table
    await db.execute('''
      CREATE TABLE milestones (
        id TEXT PRIMARY KEY,
        project_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        target_date DATETIME,
        weight INTEGER DEFAULT 1,
        depends_on TEXT,
        status INTEGER DEFAULT 0,
        completed_date DATETIME,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (project_id) REFERENCES projects(id)
      )
    ''');

    // Todos table (lightweight quick capture)
    await db.execute('''
      CREATE TABLE todos (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        category TEXT DEFAULT 'General',
        priority INTEGER DEFAULT 1,
        status INTEGER DEFAULT 0,
        due_date DATETIME,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        completed_at DATETIME
      )
    ''');

    // Finance entries table
    await db.execute('''
      CREATE TABLE finance_entries (
        id TEXT PRIMARY KEY,
        entry_date DATE NOT NULL,
        type INTEGER NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        subcategory TEXT,
        description TEXT,
        payment_method TEXT,
        tags_json TEXT,
        is_tech_investment INTEGER DEFAULT 0,
        roi_rating INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        subcategory TEXT,
        amount REAL NOT NULL,
        period TEXT DEFAULT 'monthly',
        rollover_unused INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Habits table
    await db.execute('''
      CREATE TABLE habits (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        frequency TEXT DEFAULT 'daily',
        target_count INTEGER DEFAULT 1,
        reminder_time TEXT,
        streak_current INTEGER DEFAULT 0,
        streak_longest INTEGER DEFAULT 0,
        linked_goal_id TEXT,
        last_check_in DATETIME,
        total_check_ins INTEGER DEFAULT 0,
        category TEXT,
        notes TEXT,
        priority INTEGER DEFAULT 1,
        icon TEXT,
        is_active INTEGER DEFAULT 1,
        target_date DATETIME,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Habit checks table
    await db.execute('''
      CREATE TABLE habit_checks (
        id TEXT PRIMARY KEY,
        habit_id TEXT NOT NULL,
        check_date DATE NOT NULL,
        completed INTEGER DEFAULT 0,
        notes TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (habit_id) REFERENCES habits(id),
        UNIQUE(habit_id, check_date)
      )
    ''');

    // Goals table
    await db.execute('''
      CREATE TABLE goals (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT,
        type TEXT,
        target_value REAL,
        current_value REAL DEFAULT 0,
        target_date DATETIME,
        progress_percent INTEGER DEFAULT 0,
        status INTEGER DEFAULT 0,
        unit TEXT,
        priority INTEGER DEFAULT 1,
        notes TEXT,
        milestones_completed INTEGER,
        total_milestones INTEGER,
        is_public INTEGER DEFAULT 0,
        progress_history TEXT,
        reason TEXT,
        strategy TEXT,
        frequency INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Knowledge topics table (Knowledge Vault)
    await db.execute('''
      CREATE TABLE knowledge_topics (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT,
        parent_topic_id TEXT,
        progress_percent INTEGER DEFAULT 0,
        target_hours INTEGER,
        current_hours INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (parent_topic_id) REFERENCES knowledge_topics(id)
      )
    ''');

    // Learning resources table
    await db.execute('''
      CREATE TABLE learning_resources (
        id TEXT PRIMARY KEY,
        topic_id TEXT NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        url TEXT,
        status INTEGER DEFAULT 0,
        value_rating INTEGER,
        cost REAL,
        notes TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (topic_id) REFERENCES knowledge_topics(id)
      )
    ''');

    // Notes table
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT NOT NULL,
        type TEXT DEFAULT 'text',
        tags_json TEXT,
        linked_entity_type TEXT,
        linked_entity_id TEXT,
        is_pinned INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Daily reflections table
    await db.execute('''
      CREATE TABLE daily_reflections (
        id TEXT PRIMARY KEY,
        reflection_date DATE NOT NULL UNIQUE,
        went_well TEXT,
        improve TEXT,
        gratitude TEXT,
        mood_rating INTEGER,
        goals_progress TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Daily logs table
    await db.execute('''
      CREATE TABLE daily_logs (
        id TEXT PRIMARY KEY,
        log_date DATE NOT NULL,
        log_time TIME NOT NULL,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        mood TEXT,
        tags_json TEXT,
        linked_entity_type TEXT,
        linked_entity_id TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Focus sessions table
    await db.execute('''
      CREATE TABLE focus_sessions (
        id TEXT PRIMARY KEY,
        start_time DATETIME NOT NULL,
        end_time DATETIME,
        duration_minutes INTEGER,
        intent_description TEXT,
        linked_task_id TEXT,
        linked_project_id TEXT,
        distractions_count INTEGER DEFAULT 0,
        completion_status INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (linked_task_id) REFERENCES tasks(id),
        FOREIGN KEY (linked_project_id) REFERENCES projects(id)
      )
    ''');

    // Create indexes for performance
    await db.execute('CREATE INDEX idx_tasks_status_due ON tasks(status, due_date)');
    await db.execute('CREATE INDEX idx_tasks_project ON tasks(project_id)');
    await db.execute('CREATE INDEX idx_study_sessions_date ON study_sessions(created_at)');
    await db.execute('CREATE INDEX idx_finance_entries_date ON finance_entries(entry_date, category)');
    await db.execute('CREATE INDEX idx_habit_checks_date ON habit_checks(check_date)');
    await db.execute('CREATE INDEX idx_focus_sessions_date ON focus_sessions(start_time)');
    await db.execute('CREATE INDEX idx_daily_logs_date ON daily_logs(log_date, category)');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      // Drop all old tables and recreate with new schema
      await db.execute('DROP TABLE IF EXISTS tasks');
      await db.execute('DROP TABLE IF EXISTS study_sessions');
      await db.execute('DROP TABLE IF EXISTS projects');
      await db.execute('DROP TABLE IF EXISTS milestones');
      await db.execute('DROP TABLE IF EXISTS todos');
      await db.execute('DROP TABLE IF EXISTS finance_entries');
      await db.execute('DROP TABLE IF EXISTS budgets');
      await db.execute('DROP TABLE IF EXISTS habits');
      await db.execute('DROP TABLE IF EXISTS habit_checks');
      await db.execute('DROP TABLE IF EXISTS goals');
      await db.execute('DROP TABLE IF EXISTS knowledge_topics');
      await db.execute('DROP TABLE IF EXISTS learning_resources');
      await db.execute('DROP TABLE IF EXISTS notes');
      await db.execute('DROP TABLE IF EXISTS daily_reflections');
      await db.execute('DROP TABLE IF EXISTS daily_logs');
      await db.execute('DROP TABLE IF EXISTS focus_sessions');
      
      // Recreate all tables with updated schema
      await _createDB(db, newVersion);
    }
  }

  Future<void> initialize() async {
    await database;
  }

  // Generic CRUD operations
  Future<T> runTransaction<T>(Future<T> Function(Database db) action) async {
    try {
      final db = await database;
      return await action(db);
    } catch (e) {
      debugPrint('Database error: $e');
      throw DatabaseException('Failed to execute database operation', e);
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    return runTransaction((db) async {
      try {
        return await db.query(table, orderBy: 'created_at DESC');
      } catch (e) {
        throw DatabaseException('Failed to fetch records from $table', e);
      }
    });
  }

  Future<Map<String, dynamic>?> getById(String table, String id) async {
    return runTransaction((db) async {
      final results = await db.query(table, where: 'id = ?', whereArgs: [id]);
      return results.isNotEmpty ? results.first : null;
    });
  }

  Future<String> insert(String table, Map<String, dynamic> data) async {
    return runTransaction((db) async {
      try {
        await db.insert(table, data);
        return data['id'] as String;
      } catch (e) {
        throw DatabaseException('Failed to insert record into $table', e);
      }
    });
  }

  Future<bool> update(String table, String id, Map<String, dynamic> data) async {
    final db = await database;
    final count = await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<bool> delete(String table, String id) async {
    final db = await database;
    final count = await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }
}
