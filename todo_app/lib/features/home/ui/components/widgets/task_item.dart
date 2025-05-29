import 'package:flutter/material.dart';
import 'package:todo_app/features/home/data/models/task_model.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.index, required this.task});
  final int index;
  final TaskModel task;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 20,
            children: [
              CircleAvatar(
                radius: 20,
                child: Text(index.toString(), style: TextStyle(fontSize: 20)),
              ),
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          task.date,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const Spacer(),
                        Text(
                          task.time,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
