import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/features/home/ui/components/widgets/custom_textFormField.dart';

class BottomSheetBody extends StatefulWidget {
  const BottomSheetBody({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static dynamic selectedDate;
  static dynamic selectedTime;
  static String title = '';
  @override
  State<BottomSheetBody> createState() => _BottomSheetBodyState();
}

class _BottomSheetBodyState extends State<BottomSheetBody> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: BottomSheetBody.formKey,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            Text(
              'Add New Task',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 1),
            CustomTextFormField(
              myController: titleController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Title must not be empty';
                }
                BottomSheetBody.title = value;
                return null;
              },
              label: 'Title',
              preIcon: Icons.title,
            ),
            CustomTextFormField(
              myController: timeController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Time must not be empty';
                }
                return null;
              },
              label: 'Time',
              preIcon: Icons.access_time,
              onTap: () async {
                await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    timeController.text = value.format(context);
                    BottomSheetBody.selectedTime = timeController.text;
                  }
                });
              },
            ),
            CustomTextFormField(
              myController: dateController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Date must not be empty';
                }
                return null;
              },
              label: 'Date',
              preIcon: Icons.calendar_month_sharp,
              onTap: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                ).then((value) {
                  if (value != null) {
                    dateController.text = DateFormat.yMMMEd().format(value);
                    BottomSheetBody.selectedDate = dateController.text;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
