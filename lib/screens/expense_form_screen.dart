import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/expense.dart';
import '../utils/categories.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Expense? existingExpense;

  const ExpenseFormScreen({super.key, this.existingExpense});

  bool get isEditMode => existingExpense != null;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late String _selectedCategory;
  late DateTime _selectedDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingExpense?.title ?? '',
    );
    _amountController = TextEditingController(
      text: widget.existingExpense != null
          ? widget.existingExpense!.amount.toStringAsFixed(2)
          : '',
    );
    _selectedCategory = widget.existingExpense?.category ?? kCategories.first;
    _selectedDate = widget.existingExpense?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2e7d32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1b5e20),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await Future.delayed(const Duration(milliseconds: 250));

    final result = Expense(
      id: widget.existingExpense?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _selectedCategory,
      date: _selectedDate,
    );

    if (mounted) Navigator.pop(context, result);
  }

  void _cancel() => Navigator.pop(context, null);

  String _monthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[month];
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF81c784)),
      prefixIcon: Icon(icon, color: const Color(0xFF388e3c), size: 20),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFa5d6a7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFa5d6a7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2e7d32), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFe53935)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFe53935), width: 1.8),
      ),
      errorStyle: const TextStyle(color: Color(0xFFe53935)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEditMode;
    final color = categoryColor(_selectedCategory);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf1f8f1),
              Color(0xFFe8f5e9),
              Color(0xFFc8e6c9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // ── Header ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF388e3c)),
                      onPressed: _cancel,
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit Expense' : 'New Expense',
                          style: const TextStyle(
                            color: Color(0xFF1b5e20),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          isEdit
                              ? 'Editing: ${widget.existingExpense!.title}'
                              : 'Fill in the details below',
                          style: const TextStyle(
                            color: Color(0xFF66bb6a),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Divider(color: Color(0xFFa5d6a7), thickness: 1),
              ),

              // ── Form body ────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Title
                        _FieldLabel('Title'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          autofocus: !isEdit,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                              color: Color(0xFF1b5e20), fontSize: 15),
                          decoration: _inputDecoration(
                              'e.g. SM Shopping Haul', Icons.label_outline),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Title cannot be empty'
                              : null,
                        ),

                        const SizedBox(height: 20),

                        // Amount
                        _FieldLabel('Amount (₱)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          style: const TextStyle(
                              color: Color(0xFF1b5e20), fontSize: 15),
                          decoration:
                              _inputDecoration('0.00', Icons.payments_outlined),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Amount cannot be empty';
                            }
                            final n = double.tryParse(v.trim());
                            if (n == null) return 'Enter a valid number';
                            if (n <= 0) return 'Amount must be greater than ₱0';
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Category
                        _FieldLabel('Category'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: kCategories.map((cat) {
                            final selected = _selectedCategory == cat;
                            final catColor = categoryColor(cat);
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedCategory = cat),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 9),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? catColor.withOpacity(0.15)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? catColor
                                        : const Color(0xFFa5d6a7),
                                    width: selected ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  '${categoryIcon(cat)}  $cat',
                                  style: TextStyle(
                                    color: selected
                                        ? catColor
                                        : const Color(0xFF81c784),
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        // Date
                        _FieldLabel('Date'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFa5d6a7)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    color: Color(0xFF388e3c), size: 18),
                                const SizedBox(width: 12),
                                Text(
                                  '${_monthName(_selectedDate.month)} ${_selectedDate.day}, ${_selectedDate.year}',
                                  style: const TextStyle(
                                    color: Color(0xFF1b5e20),
                                    fontSize: 15,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.chevron_right,
                                    color: Color(0xFFa5d6a7), size: 18),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Category preview badge
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: color.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Text(categoryIcon(_selectedCategory),
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 10),
                              Text(
                                isEdit
                                    ? 'Editing in $_selectedCategory'
                                    : 'Adding to $_selectedCategory',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Action buttons ───────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0xFFa5d6a7))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _cancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF388e3c),
                          side: const BorderSide(color: Color(0xFFa5d6a7)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2e7d32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 6,
                          shadowColor:
                              const Color(0xFF2e7d32).withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEdit ? '💾  Save Changes' : '✚  Add Expense',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF388e3c),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}