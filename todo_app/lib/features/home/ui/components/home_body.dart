import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/cubit/app_cubit.dart';
import 'package:todo_app/core/cubit/app_state.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          int currentIndex = cubit.currentIndex;
          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(title: Text(cubit.labels[currentIndex])),
            body:
                state is AppLoadingState
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 15,
                        children: [
                          CircularProgressIndicator(),
                          Text(
                            'No Tasks',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    )
                    : cubit.screens[currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                cubit.insertDataToBottomSheet(context);
              },
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeBottomNavigationBarIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived ',
                ),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          } else if (state is AppLoadingState) {
          } else if (state is AppLoadingState) {
            Center(child: CircularProgressIndicator());
          } else if (AppCubit.get(context).newTasks.isEmpty) {
            Center(child: Text("No tasks yet"));
          }
        },
      ),
    );
  }
}
