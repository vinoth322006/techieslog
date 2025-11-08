import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/providers/app_state.dart';
import '../../core/models/daily_log.dart';
import '../../core/models/note.dart';

class PremiumLogsCalendar extends StatefulWidget {
  const PremiumLogsCalendar({super.key});

  @override
  State<PremiumLogsCalendar> createState() => _PremiumLogsCalendarState();
}

class _PremiumLogsCalendarState extends State<PremiumLogsCalendar> with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  bool _showCalendar = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          // Tab Bar
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
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.teal,
                    indicatorWeight: 3,
                    labelColor: Colors.teal,
                    unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Logs'),
                      Tab(text: 'Notes'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLogsTab(isDark),
                _buildNotesTab(isDark),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => _showAddLogModal(context),
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add_rounded, size: 28),
            )
          : null,
    );
  }

  Widget _buildLogsTab(bool isDark) {
    return Column(
      children: [
        // Calendar toggle header for Logs tab
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_showCalendar ? 'Select Date' : 'Today\'s Logs', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
              GestureDetector(
                onTap: () => setState(() => _showCalendar = !_showCalendar),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.calendar_today_rounded, color: Colors.teal, size: 28),
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar section (collapsible)
                  if (_showCalendar) ...[
                    _buildCalendarSection(isDark),
                    const SizedBox(height: 20),
                    _buildSelectedDateLogs(isDark),
                  ] else ...[
                    // Today's Log section
                    _buildTodaysLogSection(isDark),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesTab(bool isDark) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildNotesSection(isDark),
      ),
    );
  }

  Widget _buildCalendarSection(bool isDark) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.all(12),
          child: TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDate = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
              weekendTextStyle: TextStyle(color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
              selectedDecoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: Colors.teal.withOpacity(0.3), shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              leftChevronIcon: Icon(Icons.chevron_left_rounded, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
              rightChevronIcon: Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
              titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontWeight: FontWeight.w600),
              weekendStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
            eventLoader: (day) {
              return appState.dailyLogs
                  .where((log) =>
                      log.logDate.year == day.year &&
                      log.logDate.month == day.month &&
                      log.logDate.day == day.day)
                  .toList();
            },
          ),
        );
      },
    );
  }

  Widget _buildTodaysLogSection(bool isDark) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final today = DateTime.now();
        final todayLogs = appState.dailyLogs
            .where((log) =>
                log.logDate.year == today.year &&
                log.logDate.month == today.month &&
                log.logDate.day == today.day)
            .toList();

        final moodCounts = <String, int>{};
        for (var log in todayLogs) {
          moodCounts[log.mood ?? 'Neutral'] = (moodCounts[log.mood ?? 'Neutral'] ?? 0) + 1;
        }
        final dominantMood = moodCounts.isEmpty
            ? 'Neutral'
            : moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood & Stats Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.teal, Colors.teal.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Today\'s Mood', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(LogMoods.getEmoji(dominantMood), style: const TextStyle(fontSize: 32)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Text('${todayLogs.length}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                        Text('Entries', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Logs List
            if (todayLogs.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.book_rounded, size: 48, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                      const SizedBox(height: 12),
                      Text('No logs yet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todayLogs.length,
                itemBuilder: (context, index) => _buildLogCard(todayLogs[index], isDark, () => _deleteLog(todayLogs[index], context)),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAddLogSection(bool isDark) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Personal';
    String selectedMood = 'Neutral';

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick Log', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
              const SizedBox(height: 10),
              TextField(controller: titleController, decoration: InputDecoration(hintText: 'What\'s on your mind?', hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)), style: TextStyle(color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
              const SizedBox(height: 10),
              TextField(controller: contentController, maxLines: 2, decoration: InputDecoration(hintText: 'Details...', hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)), style: TextStyle(color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        onChanged: (value) => setState(() => selectedCategory = value ?? 'Personal'),
                        underline: const SizedBox(),
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        items: LogCategories.all.map((c) => DropdownMenuItem(value: c, child: Text('${LogCategories.getIcon(c)} $c', style: TextStyle(color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A), fontSize: 12)))).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                      child: DropdownButton<String>(
                        value: selectedMood,
                        onChanged: (value) => setState(() => selectedMood = value ?? 'Neutral'),
                        underline: const SizedBox(),
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        items: LogMoods.all.map((m) => DropdownMenuItem(value: m, child: Text('${LogMoods.getEmoji(m)} $m', style: TextStyle(color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A), fontSize: 12)))).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => _addLog(context, titleController, contentController, selectedCategory, selectedMood), icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white), label: const Text('Save Log', style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogCard(DailyLog log, bool isDark, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                          Text(LogMoods.getEmoji(log.mood ?? 'Neutral'), style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(log.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(log.logTime, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.teal.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text('${LogCategories.getIcon(log.category)} ${log.category}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.teal))),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(onTap: onDelete, child: Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red.withOpacity(0.7))),
              ],
            ),
            if (log.content != null && log.content!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(log.content ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), height: 1.4)),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _addLog(BuildContext context, TextEditingController titleController, TextEditingController contentController, String category, String mood) async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final appState = Provider.of<AppState>(context, listen: false);
    final now = DateTime.now();
    final newLog = DailyLog(
      id: DateTime.now().toString(),
      logDate: now,
      logTime: DateFormat('HH:mm').format(now),
      category: category,
      title: titleController.text,
      content: contentController.text,
      mood: mood,
      tags: null,
      linkedEntityType: null,
      linkedEntityId: null,
      createdAt: now,
      updatedAt: now,
    );

    await appState.addDailyLog(newLog);
    titleController.clear();
    contentController.clear();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log saved! ✓'), duration: Duration(seconds: 1)));
  }

  void _deleteLog(DailyLog log, BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.deleteDailyLog(log.id);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log deleted'), duration: Duration(seconds: 1)));
  }

  void _showAddLogModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Personal';
    String selectedMood = 'Neutral';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    Text(
                      'Add New Log',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close_rounded,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title field
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          hintStyle: TextStyle(
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
                          ),
                          labelText: 'Title *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        style: TextStyle(
                          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Content field
                      TextField(
                        controller: contentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Details...',
                          hintStyle: TextStyle(
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
                          ),
                          labelText: 'Details',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        style: TextStyle(
                          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Category and Mood dropdowns
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: DropdownButton<String>(
                                value: selectedCategory,
                                onChanged: (value) => setState(() => selectedCategory = value ?? 'Personal'),
                                underline: const SizedBox(),
                                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                items: LogCategories.all
                                    .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(
                                            '${LogCategories.getIcon(c)} $c',
                                            style: TextStyle(
                                              color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: DropdownButton<String>(
                                value: selectedMood,
                                onChanged: (value) => setState(() => selectedMood = value ?? 'Neutral'),
                                underline: const SizedBox(),
                                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                                items: LogMoods.all
                                    .map((m) => DropdownMenuItem(
                                          value: m,
                                          child: Text(
                                            '${LogMoods.getEmoji(m)} $m',
                                            style: TextStyle(
                                              color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                              label: const Text('Cancel', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.withOpacity(0.6),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _addLog(context, titleController, contentController, selectedCategory, selectedMood);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                              label: const Text('Save Log', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDateLogs(bool isDark) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final selectedDateLogs = appState.dailyLogs
            .where((log) =>
                log.logDate.year == _selectedDate.year &&
                log.logDate.month == _selectedDate.month &&
                log.logDate.day == _selectedDate.day)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Logs for ${DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
            const SizedBox(height: 12),
            if (selectedDateLogs.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 48, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                      const SizedBox(height: 12),
                      Text('No logs for this date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedDateLogs.length,
                itemBuilder: (context, index) => _buildDetailedLogCard(selectedDateLogs[index], isDark, () => _deleteLog(selectedDateLogs[index], context)),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDetailedLogCard(DailyLog log, bool isDark, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
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
                          Text(LogMoods.getEmoji(log.mood ?? 'Neutral'), style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(log.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(log.logTime, style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                          const SizedBox(width: 12),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.teal.withOpacity(0.15), borderRadius: BorderRadius.circular(4)), child: Text('${LogCategories.getIcon(log.category)} ${log.category}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.teal))),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(onTap: onDelete, child: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red.withOpacity(0.7))),
              ],
            ),
            if (log.content != null && log.content!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                child: Text(log.content ?? '', style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A), height: 1.5)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(bool isDark) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final notes = appState.notes;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Create New Note Button
            GestureDetector(
              onTap: () => _openNoteEditor(context, isDark, null),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.teal, Colors.teal.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create New Note', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text('Start writing...', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.8), size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Notes Grid
            if (notes.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Icon(Icons.note_rounded, size: 64, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                      const SizedBox(height: 16),
                      Text('No notes yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
                      const SizedBox(height: 8),
                      Text('Create your first note to get started', style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    ],
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onTap: () => _openNoteEditor(context, isDark, note),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  note.title ?? 'Untitled',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final appState = Provider.of<AppState>(context, listen: false);
                                  await appState.deleteNote(note.id);
                                },
                                child: Icon(Icons.close_rounded, size: 18, color: Colors.red.withOpacity(0.6)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              note.content ?? '',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B), height: 1.5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            DateFormat('MMM d, yyyy').format(note.createdAt),
                            style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  void _openNoteEditor(BuildContext context, bool isDark, Note? note) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    final isEditing = note != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(isEditing ? 'Edit Note' : 'New Note', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A))),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.close_rounded, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), size: 24),
                          ),
                        ],
                      ),
                    ),
                    // Editor
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title field
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  hintText: 'Note title',
                                  hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1), fontSize: 16),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A)),
                                maxLines: null,
                              ),
                              const SizedBox(height: 16),
                              // Divider
                              Container(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                              const SizedBox(height: 16),
                              // Content field
                              TextField(
                                controller: contentController,
                                decoration: InputDecoration(
                                  hintText: 'Start typing...',
                                  hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1), fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A), height: 1.6),
                                maxLines: null,
                                minLines: 10,
                              ),
                              const SizedBox(height: 24),
                              // Action buttons
                              Row(
                                children: [
                                  if (isEditing)
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final appState = Provider.of<AppState>(context, listen: false);
                                          Navigator.pop(context);
                                          await appState.deleteNote(note!.id);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note deleted'), duration: Duration(seconds: 1)));
                                        },
                                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white),
                                        label: const Text('Delete', style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.8), foregroundColor: Colors.white),
                                      ),
                                    ),
                                  if (isEditing) const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        if (titleController.text.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
                                          return;
                                        }
                                        final appState = Provider.of<AppState>(context, listen: false);
                                        Navigator.pop(context);
                                        
                                        if (isEditing) {
                                          final updatedNote = Note(
                                            id: note!.id,
                                            title: titleController.text,
                                            content: contentController.text,
                                            type: 'text',
                                            isPinned: note.isPinned,
                                            createdAt: note.createdAt,
                                            updatedAt: DateTime.now(),
                                          );
                                          await appState.updateNote(updatedNote);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note updated! ✓'), duration: Duration(seconds: 1)));
                                        } else {
                                          final newNote = Note(
                                            id: DateTime.now().toString(),
                                            title: titleController.text,
                                            content: contentController.text,
                                            type: 'text',
                                            isPinned: false,
                                            createdAt: DateTime.now(),
                                            updatedAt: DateTime.now(),
                                          );
                                          await appState.addNote(newNote);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note saved! ✓'), duration: Duration(seconds: 1)));
                                        }
                                      },
                                      icon: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                                      label: Text(isEditing ? 'Update' : 'Save', style: const TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
