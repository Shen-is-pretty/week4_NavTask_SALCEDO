import 'package:flutter/material.dart';
import 'package:flutter_expensenav/models/expense.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? existing; // null = Add mode, non-null = Edit mode

  const AddExpensePage({super.key, this.existing});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  String? _titleError;
  String? _amountError;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existing?.title ?? '');
    _amountController = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.amount.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    String? titleErr;
    String? amountErr;

    if (title.isEmpty) {
      titleErr = 'Expense title cannot be empty.';
    }

    if (amountText.isEmpty) {
      amountErr = 'Amount cannot be empty.';
    } else {
      final parsed = double.tryParse(amountText);
      if (parsed == null) {
        amountErr = 'Please enter a valid number.';
      } else if (parsed <= 0) {
        amountErr = 'Amount must be greater than 0.';
      }
    }

    if (titleErr != null || amountErr != null) {
      setState(() {
        _titleError = titleErr;
        _amountError = amountErr;
      });
      return;
    }

    Navigator.pop(
      context,
      Expense(title: title, amount: double.parse(amountText)),
    );
  }

  void _cancel() => Navigator.pop(context, null);

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF388e3c)),
                      onPressed: _cancel,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isEditMode ? 'Edit Expense' : 'Add Expense',
                      style: const TextStyle(
                        color: Color(0xFF1b5e20),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Divider(color: Color(0xFFa5d6a7), thickness: 1),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title field
                    const Text(
                      'EXPENSE TITLE',
                      style: TextStyle(
                        color: Color(0xFF388e3c),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      autofocus: !_isEditMode,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                          color: Color(0xFF1b5e20), fontSize: 15),
                      onChanged: (_) {
                        if (_titleError != null) {
                          setState(() => _titleError = null);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'e.g. Daily Allowance',
                        hintStyle: const TextStyle(color: Color(0xFF81c784)),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: _titleError,
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
                          borderSide: const BorderSide(
                              color: Color(0xFF2e7d32), width: 1.8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFe53935)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFe53935), width: 1.8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Amount field
                    const Text(
                      'AMOUNT (₱)',
                      style: TextStyle(
                        color: Color(0xFF388e3c),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                          color: Color(0xFF1b5e20), fontSize: 15),
                      onChanged: (_) {
                        if (_amountError != null) {
                          setState(() => _amountError = null);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'e.g. 500.00',
                        hintStyle: const TextStyle(color: Color(0xFF81c784)),
                        prefixText: '₱  ',
                        prefixStyle: const TextStyle(
                            color: Color(0xFF388e3c),
                            fontWeight: FontWeight.w600),
                        filled: true,
                        fillColor: Colors.white,
                        errorText: _amountError,
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
                          borderSide: const BorderSide(
                              color: Color(0xFF2e7d32), width: 1.8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFe53935)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFe53935), width: 1.8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Save button
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2e7d32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 4,
                        shadowColor:
                            const Color(0xFF2e7d32).withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _isEditMode ? 'Save Changes' : 'Save',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Cancel button
                    OutlinedButton(
                      onPressed: _cancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF388e3c),
                        side: const BorderSide(color: Color(0xFFa5d6a7)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
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