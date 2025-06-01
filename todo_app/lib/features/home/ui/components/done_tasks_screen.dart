import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/cubit/app_cubit.dart';
import 'package:todo_app/core/cubit/app_state.dart';
import 'package:todo_app/features/home/ui/components/widgets/task_item.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ListView.builder(
          itemBuilder: (context, listIndex) {
            return TaskItem(
              done: false,
              archived: true,
              index: listIndex + 1,
              task: cubit.doneTasks[listIndex],
            );
          },
          itemCount: cubit.doneTasks.length,
        );
      },
    );
  }
}
