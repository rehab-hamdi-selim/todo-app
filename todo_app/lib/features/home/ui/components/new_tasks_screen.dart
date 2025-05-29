import 'package:flutter/material.dart';
import 'package:todo_app/features/home/ui/components/widgets/task_listview.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TasksListview(),
    );
  }
}
