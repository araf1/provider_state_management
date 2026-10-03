import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_dialog.dart';

class TaskManagerScreen extends StatelessWidget {
  const TaskManagerScreen({super.key});

  Future<void> _showAddTaskDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AddTaskDialog(
        onSubmit: (title, description) {
          context.read<TaskProvider>().addTask(
            title: title,
            description: description,
          );
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF19796D).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.checklist_rounded,
                color: Color(0xFF19796D),
                size: 21,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Daymark',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your focus,\nin one place.',
                    style: TextStyle(
                      color: Color(0xFF202C2A),
                      fontSize: 30,
                      height: 1.12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Small steps add up. Keep yours moving.',
                    style: TextStyle(
                      color: const Color(0xFF202C2A).withValues(alpha: 0.62),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _TaskStatistic(
                          label: 'Total',
                          value: taskProvider.totalTasks,
                          icon: Icons.format_list_bulleted_rounded,
                          color: const Color(0xFF315D72),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TaskStatistic(
                          label: 'Completed',
                          value: taskProvider.completedTasks,
                          icon: Icons.check_circle_outline_rounded,
                          color: const Color(0xFF19796D),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TaskStatistic(
                          label: 'Pending',
                          value: taskProvider.pendingTasks,
                          icon: Icons.hourglass_bottom_rounded,
                          color: const Color(0xFFB66A36),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Text(
                          'Your tasks',
                          style: TextStyle(
                            color: Color(0xFF202C2A),
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${tasks.length} ${tasks.length == 1 ? 'ITEM' : 'ITEMS'}',
                        style: const TextStyle(
                          color: Color(0xFF74817A),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: tasks.isEmpty ? 1 : tasks.length,
                      itemBuilder: (context, index) {
                        if (tasks.isEmpty) return const _EmptyTasks();
                        return _TaskTile(task: tasks[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
      ),
    );
  }
}

class _TaskStatistic extends StatelessWidget {
  const _TaskStatistic({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5EAE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 9),
          Text(
            '$value',
            style: const TextStyle(
              color: Color(0xFF202C2A),
              fontSize: 21,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                color: Color(0xFF74817A),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final statusColor = task.isCompleted
        ? const Color(0xFF19796D)
        : const Color(0xFFB66A36);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(8, 9, 6, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5EAE5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox.adaptive(
            value: task.isCompleted,
            activeColor: const Color(0xFF19796D),
            onChanged: (_) => context.read<TaskProvider>().toggleTask(task.id),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 9, bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: task.isCompleted
                          ? const Color(0xFF87918B)
                          : const Color(0xFF202C2A),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF74817A),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 7),
                  Text(
                    task.isCompleted ? 'COMPLETED' : 'IN PROGRESS',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Delete task',
            onPressed: () => context.read<TaskProvider>().deleteTask(task.id),
            icon: const Icon(Icons.delete_outline_rounded),
            color: const Color(0xFF8A9690),
            iconSize: 21,
          ),
        ],
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE5EFEB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: Color(0xFF19796D),
              size: 30,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'A clear page.',
            style: TextStyle(
              color: Color(0xFF202C2A),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Add a task to get started.',
            style: TextStyle(color: Color(0xFF74817A), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
