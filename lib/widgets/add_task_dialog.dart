import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onSubmit});

  final void Function(String title, String description) onSubmit;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(_titleController.text, _descriptionController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'New task',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  hintText: 'What needs to get done?',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a task title'
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Add a little more detail',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add task'),
        ),
      ],
    );
  }
}
