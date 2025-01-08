import 'package:flutter/material.dart';
import '../models/expense_category.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(ExpenseCategory) onAdd; // Callback to pass the entire ExpenseCategory object

  const AddCategoryDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Category Name'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without doing anything
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final categoryName = _nameController.text;
            if (categoryName.isNotEmpty) {
              // Create a new ExpenseCategory object
              final newCategory = ExpenseCategory(
                id: DateTime.now().toString(), // Use a unique ID
                name: categoryName,
                isDefault: false, // Mark it as user-added
              );

              widget.onAdd(newCategory); // Pass the entire object to the callback
              Navigator.of(context).pop(); // Close the dialog
            } else {
              // Show an error if the name is empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Category name cannot be empty!')),
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}