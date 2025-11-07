import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/providers/app_state.dart';
import '../../core/models/finance_entry.dart';
import '../../core/models/budget.dart';
import 'package:uuid/uuid.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';

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
    final appState = Provider.of<AppState>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(bottom: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), width: 1)),
            ),
            child: SafeArea(
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                indicatorWeight: 3,
                labelColor: Colors.green,
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Transactions'),
                  Tab(text: 'Budgets'),
                ],
              ),
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTransactionsTab(),
                _buildBudgetsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionDialog(appState),
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final entries = _getFilteredEntries(appState.financeEntries);
        final income = entries.where((e) => e.type == 1).fold<double>(0, (sum, e) => sum + e.amount);
        final expenses = entries.where((e) => e.type == 0).fold<double>(0, (sum, e) => sum + e.amount);
        final balance = income - expenses;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: balance >= 0 
                      ? [Color(0xFF667eea), Color(0xFF764ba2)]
                      : [Color(0xFFef4444), Color(0xFFdc2626)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (balance >= 0 ? Color(0xFF667eea) : Color(0xFFef4444)).withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    balance >= 0 ? 'You\'re doing great!' : 'Expenses exceed income',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showSetBalanceDialog(appState, balance),
                    icon: const Icon(Icons.account_balance_wallet, size: 18),
                    label: const Text('Set Balance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: balance >= 0 ? Color(0xFF667eea) : Color(0xFFef4444),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.arrow_downward, color: Colors.green, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${income.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.arrow_upward, color: Colors.red, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          'Expenses',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${expenses.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildCategoryChart(entries),
            const SizedBox(height: 24),
            _buildRecentTransactions(entries.take(5).toList()),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChart(List<FinanceEntry> entries) {
    final expenses = entries.where((e) => e.type == 0).toList();
    if (expenses.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text('No expenses to display', 
              style: TextStyle(color: Colors.grey[600])
            ),
          ),
        ),
      );
    }

    final categoryTotals = <String, double>{};
    for (var entry in expenses) {
      categoryTotals[entry.category] = (categoryTotals[entry.category] ?? 0) + entry.amount;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expenses by Category', 
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categoryTotals.entries.map((entry) {
                    final index = categoryTotals.keys.toList().indexOf(entry.key);
                    final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple];
                    return PieChartSectionData(
                      value: entry.value,
                      title: '₹${entry.value.toStringAsFixed(0)}',
                      color: colors[index % colors.length],
                      radius: 80,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...categoryTotals.entries.map((entry) {
              final index = categoryTotals.keys.toList().indexOf(entry.key);
              final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: colors[index % colors.length],
                    ),
                    const SizedBox(width: 8),
                    Text(entry.key),
                    const Spacer(),
                    Text('₹${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(List<FinanceEntry> entries) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Recent Transactions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No transactions yet')),
            )
          else
            ...entries.map((entry) => ListTile(
              leading: CircleAvatar(
                backgroundColor: entry.type == 1 ? Colors.green : Colors.red,
                child: Icon(
                  entry.type == 1 ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
              title: Text(entry.description ?? entry.category),
              subtitle: Text(DateFormat('MMM d, y').format(entry.entryDate)),
              trailing: Text(
                '₹${entry.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: entry.type == 1 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final entries = _getFilteredEntries(appState.financeEntries);
        
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No transactions yet',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: entry.type == 1 ? Colors.green : Colors.red,
                  child: Icon(
                    entry.type == 1 ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
                title: Text(entry.description ?? entry.category),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.category),
                    Text(DateFormat('MMM d, y').format(entry.entryDate)),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${entry.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: entry.type == 1 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (entry.isTechInvestment)
                      const Icon(Icons.computer, size: 16, color: Colors.blue),
                  ],
                ),
                onTap: () => _showEditTransactionDialog(entry, appState),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBudgetsTab() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final budgets = appState.budgets;
        
        if (budgets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.savings, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No budgets set',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddBudgetDialog(appState),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Budget'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: budgets.length + 1,
          itemBuilder: (context, index) {
            if (index == budgets.length) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton.icon(
                  onPressed: () => _showAddBudgetDialog(appState),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Budget'),
                ),
              );
            }

            final budget = budgets[index];
            final spent = _getSpentInCategory(appState.financeEntries, budget.category);
            final percentage = (spent / budget.amount * 100).clamp(0, 100);
            final isOverBudget = spent > budget.amount;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(budget.category,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          color: Colors.red,
                          onPressed: () => appState.deleteBudget(budget.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹${spent.toStringAsFixed(2)} / ₹${budget.amount.toStringAsFixed(2)}'),
                        Text('${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: isOverBudget ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(
                        isOverBudget ? Colors.red : Colors.green,
                      ),
                    ),
                    if (isOverBudget)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Over budget by ₹${(spent - budget.amount).toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.red, fontSize: 12),
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

  List<FinanceEntry> _getFilteredEntries(List<FinanceEntry> entries) {
    final now = DateTime.now();
    return entries.where((entry) {
      switch (_selectedPeriod) {
        case 'This Week':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          return entry.entryDate.isAfter(weekStart);
        case 'This Month':
          return entry.entryDate.year == now.year && entry.entryDate.month == now.month;
        case 'This Year':
          return entry.entryDate.year == now.year;
        default:
          return true;
      }
    }).toList()..sort((a, b) => b.entryDate.compareTo(a.entryDate));
  }

  double _getSpentInCategory(List<FinanceEntry> entries, String category) {
    final now = DateTime.now();
    return entries
        .where((e) => e.type == 0 && 
                     e.category == category && 
                     e.entryDate.year == now.year && 
                     e.entryDate.month == now.month)
        .fold<double>(0, (sum, e) => sum + e.amount);
  }

  void _showAddTransactionDialog(AppState appState) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    int type = 0; // 0=Expense, 1=Income
    String category = 'Food';
    DateTime selectedDate = DateTime.now();
    bool isTechInvestment = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Transaction'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Expense'), icon: Icon(Icons.arrow_upward)),
                    ButtonSegment(value: 1, label: Text('Income'), icon: Icon(Icons.arrow_downward)),
                  ],
                  selected: {type},
                  onSelectionChanged: (Set<int> selection) {
                    setState(() => type = selection.first);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount *',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Food', 'Transport', 'Shopping', 'Education', 'Entertainment', 'Health', 'Other']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) => setState(() => category = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(DateFormat('MMM d, y').format(selectedDate)),
                ),
                if (type == 0)
                  CheckboxListTile(
                    title: const Text('Tech Investment'),
                    value: isTechInvestment,
                    onChanged: (value) => setState(() => isTechInvestment = value!),
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
                if (amountController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter amount')),
                  );
                  return;
                }

                final entry = FinanceEntry(
                  id: const Uuid().v4(),
                  entryDate: selectedDate,
                  type: type,
                  amount: double.parse(amountController.text),
                  category: category,
                  description: descriptionController.text.trim().isEmpty 
                      ? null 
                      : descriptionController.text.trim(),
                  isTechInvestment: isTechInvestment,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                Navigator.pop(context);
                appState.addFinanceEntry(entry);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTransactionDialog(FinanceEntry entry, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ₹${entry.amount.toStringAsFixed(2)}'),
            Text('Category: ${entry.category}'),
            Text('Date: ${DateFormat('MMM d, y').format(entry.entryDate)}'),
            if (entry.description != null) Text('Description: ${entry.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              appState.deleteFinanceEntry(entry.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddBudgetDialog(AppState appState) {
    final amountController = TextEditingController();
    String category = 'Food';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) => AlertDialog(
          title: const Text('Add Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['Food', 'Transport', 'Shopping', 'Education', 'Entertainment', 'Health', 'Other']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => category = value!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Budget *',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
                if (amountController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter amount')),
                  );
                  return;
                }

                final budget = Budget(
                  id: const Uuid().v4(),
                  category: category,
                  amount: double.parse(amountController.text),
                  period: 'monthly',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                Navigator.pop(context);
                appState.addBudget(budget);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetBalanceDialog(AppState appState, double currentBalance) {
    final balanceController = TextEditingController(text: currentBalance.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Set Balance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current Balance: ₹${currentBalance.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: balanceController,
              decoration: const InputDecoration(
                labelText: 'New Balance *',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                helperText: 'This will add an income entry to match the balance',
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (balanceController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a balance amount')),
                );
                return;
              }

              final newBalance = double.parse(balanceController.text);
              final difference = newBalance - currentBalance;

              if (difference != 0) {
                final entry = FinanceEntry(
                  id: const Uuid().v4(),
                  type: difference > 0 ? 1 : 0, // 1=Income, 0=Expense
                  entryDate: DateTime.now(),
                  amount: difference.abs(),
                  category: 'Balance Adjustment',
                  description: 'Balance set to ₹${newBalance.toStringAsFixed(2)}',
                  isTechInvestment: false,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                appState.addFinanceEntry(entry);
              }

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Balance updated to ₹${newBalance.toStringAsFixed(2)}')),
              );
            },
            child: const Text('Set Balance'),
          ),
        ],
      ),
    );
  }
}
