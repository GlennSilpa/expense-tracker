import 'package:flutter/material.dart';
import '../models/tag.dart';

class AddTagDialog extends StatefulWidget {
  final Function(Tag) onAdd; // Update to accept a Tag callback

  const AddTagDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddTagDialogState createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Tag'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Tag Name'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final tagName = _nameController.text.trim();
            if (tagName.isNotEmpty) {
              final newTag = Tag(id: DateTime.now().toString(), name: tagName);
              widget.onAdd(newTag); // Return a Tag object
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tag name cannot be empty')),
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