import 'package:flutter/material.dart';
import '../model/task_model.dart';
import '../providers/task_provider.dart';
import '../services/firestore_task_services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddEditTaskScreen({
    super.key,
    this.task,
  });

  @override
  State<AddEditTaskScreen> createState() =>
      _AddEditTaskScreenState();
}

class _AddEditTaskScreenState
    extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  bool completed = false;
  bool isSaving = false;

  // Brown color used throughout the screen
  static const Color brownColor = Color(0xff795548);

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text =
          widget.task!.description;
      completed = widget.task!.isCompleted;
    }
  }

  Future<void> saveTask() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    final task = TaskModel(
      id: widget.task?.id ?? const Uuid().v4(),
      uid: FirestoreTaskService().currentUserId,
      title: titleController.text.trim(),
      description:
      descriptionController.text.trim(),
      createdAt:
      widget.task?.createdAt ??
          DateTime.now(),
      isCompleted: completed,
    );

    if (widget.task == null) {
      await context
          .read<TaskProvider>()
          .addTask(task);
    } else {
      await context
          .read<TaskProvider>()
          .updateTask(task);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.task == null
              ? "Task added successfully!"
              : "Task updated successfully!",
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brownColor,
        foregroundColor: Colors.white,
        title: Text(
          widget.task == null
              ? "Add Task"
              : "Edit Task",
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              TextFormField(
                controller: titleController,

                decoration: const InputDecoration(
                  labelText: "Task Title",
                  hintText: "Enter task title",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter a task title";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller:
                descriptionController,

                maxLines: 5,

                decoration:
                const InputDecoration(
                  labelText: "Description",
                  hintText:
                  "Enter task description",
                  border:
                  OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter a description";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              CheckboxListTile(
                value: completed,

                title: const Text(
                  "Mark as Completed",
                ),

                controlAffinity:
                ListTileControlAffinity.leading,

                activeColor: brownColor,

                onChanged: (value) {
                  setState(() {
                    completed =
                        value ?? false;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                width: double.infinity,

                child: ElevatedButton(
                  onPressed:
                  isSaving ? null : saveTask,

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    brownColor,
                    foregroundColor:
                    Colors.white,

                    disabledBackgroundColor:
                    brownColor.withOpacity(
                        0.6),

                    disabledForegroundColor:
                    Colors.white,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),

                  child: isSaving
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                      Colors.white,
                    ),
                  )
                      : Text(
                    widget.task == null
                        ? "Add Task"
                        : "Update Task",
                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}