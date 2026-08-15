import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/task_model.dart';
import '../providers/task_provider.dart';
import 'add_edit_task_screen.dart';
import 'package:provider/provider.dart';
class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;
  const TaskDetailScreen({
    super.key,
    required this.task,
  });
  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}
class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskModel task;
  @override
  void initState() {
    super.initState();
    task = widget.task;
  }
  Future<void> deleteTask() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text(
            "Are you sure you want to delete this task?\n\nThis action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        ),
        onPressed: () {
        Navigator.pop(context, true);
        },
        child: const Text("Delete"),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      await context
        .read<TaskProvider>()
        .deleteTask(task.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task deleted successfully.")),
      );
      Navigator.pop(context, true);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        title: const Text("Task Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(task.description,
                      style: const TextStyle(
                        fontSize: 16),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat("dd MMM yyyy",).format(task.createdAt),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.flag),
                        const SizedBox(width: 10),
                        Chip(
                          label: Text(
                            task.isCompleted ? "Completed" : "Pending"),
                          backgroundColor: task.isCompleted
                              ? Colors.green : Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text(
                  "Edit Task",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff795548),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditTaskScreen(
                        task: task,
                      ),
                    ),
                  );

                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text(
                  "Delete Task",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                  onPressed: () async {
                    await deleteTask();
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}