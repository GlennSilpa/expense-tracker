import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/add_tag_dialog.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? initialExpense;
  const AddExpenseScreen({Key? key, this.initialExpense}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _payeeController;
  late TextEditingController _noteController;
  String? _selectedCategoryId;
  String? _selectedTagId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.initialExpense?.amount.toString() ?? '');
    _payeeController =
        TextEditingController(text: widget.initialExpense?.payee ?? '');
    _noteController =
        TextEditingController(text: widget.initialExpense?.note ?? '');
    _selectedDate = widget.initialExpense?.date ?? DateTime.now();
    _selectedCategoryId = widget.initialExpense?.categoryId;
    _selectedTagId = widget.initialExpense?.tag;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialExpense == null ? 'Add Expense' : 'Edit Expense'),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(_amountController, 'Amount',
                TextInputType.numberWithOptions(decimal: true)),
            buildTextField(_payeeController, 'Payee', TextInputType.text),
            buildTextField(_noteController, 'Note', TextInputType.text),
            buildDateField(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildCategoryDropdown(expenseProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildTagDropdown(expenseProvider),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: _saveExpense,
          child: Text('Save Expense'),
        ),
      ),
    );
  }

  void _saveExpense() {
    if (_amountController.text.isEmpty ||
        _payeeController.text.isEmpty ||
        _selectedCategoryId == null ||
        _selectedTagId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields!')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount!')),
      );
      return;
    }

    final expense = Expense(
      id: widget.initialExpense?.id ?? DateTime.now().toString(),
      amount: amount,
      categoryId: _selectedCategoryId!,
      payee: _payeeController.text,
      note: _noteController.text,
      date: _selectedDate,
      tag: _selectedTagId!,
    );

    Provider.of<ExpenseProvider>(context, listen: false)
        .addOrUpdateExpense(expense);
    Navigator.pop(context);
  }

  Widget buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: type,
      ),
    );
  }

  Widget buildDateField() {
    return ListTile(
      title: Text("Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  Widget buildCategoryDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddCategoryDialog(
              onAdd: (newCategory) {
                setState(() {
                  _selectedCategoryId = newCategory.id;
                  provider.addCategory(newCategory);
                });
              },
            ),
          );
        } else {
          setState(() => _selectedCategoryId = newValue);
        }
      },
      items: provider.categories.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList()
        ..add(DropdownMenuItem(
          value: "New",
          child: Text("Add New Category"),
        )),
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildTagDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTagId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddTagDialog(
              onAdd: (newTag) {
                provider.addTag(newTag);
                setState(() => _selectedTagId = newTag.id);
              },
            ),
          );
        } else {
          setState(() => _selectedTagId = newValue);
        }
      },
      items: provider.tags.map<DropdownMenuItem<String>>((tag) {
        return DropdownMenuItem<String>(
          value: tag.id,
          child: Text(tag.name),
        );
      }).toList()
        ..add(DropdownMenuItem(
          value: "New",
          child: Text("Add New Tag"),
        )),
      decoration: InputDecoration(
        labelText: 'Tag',
        border: OutlineInputBorder(),
      ),
    );
  }
}