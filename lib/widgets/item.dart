import 'package:flutter/material.dart';

class ToDoItem extends StatefulWidget {
  final int id;
  final String description;
  final bool checked;
  final Function(int, String, bool) onEdit;
  final Function(int) onDelete;

  const ToDoItem({
    Key? key,
    required this.id,
    required this.description,
    required this.checked,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ToDoItemState createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  late String editedDescription;
  bool isEditing = false;
  late bool checked;
  final controller = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    editedDescription = widget.description;
    checked = widget.checked;
    controller.value = controller.value.copyWith(
      text: widget.description, // Set initial text here
      selection: TextSelection.collapsed(offset: widget.description.length), // Set cursor position
    );
  }


  

  @override
  Widget build(BuildContext context) {
    
    return Row(
      children: [
        const SizedBox(width: 20),
        Checkbox(
          value: checked,
          onChanged: (value) {
            setState(() {
              checked = !checked;
              widget.onEdit(widget.id, editedDescription, checked);
            });
          },
        ),
        Expanded(
          child: isEditing
              ? TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'To-Do Description',
                  ),
                  onChanged: (text) {
                    setState(() {
                      editedDescription = text;
                      controller.text = editedDescription;
                    });
                  },
                  controller: controller, // Set initial value
                )
              : Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 16,
                    decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.done : Icons.edit),
          color: isEditing ? Colors.green : Colors.black54,
          onPressed: () {
            setState(() {
              isEditing = !isEditing;
              if (!isEditing) {
                widget.onEdit(widget.id, editedDescription, checked); // Callback to update description
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.close),
          color: Colors.red,
          onPressed: () {
            widget.onDelete(widget.id); // Callback to delete item
          },
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
