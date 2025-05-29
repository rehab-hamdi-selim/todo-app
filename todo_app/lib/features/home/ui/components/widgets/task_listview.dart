import 'package:flutter/material.dart';
import 'package:todo_app/core/constants.dart';
import 'package:todo_app/features/home/ui/components/widgets/task_item.dart';

class TasksListview extends StatelessWidget {
  const TasksListview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, listIndex) {
        return TaskItem(index: listIndex + 1, task: allTasks[listIndex]);
      },
      itemCount: allTasks.length,
    );
  }
}
