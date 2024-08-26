import 'dart:ffi';

import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;
  final onFavoriteItem;
  final onSetStartDateTime;
  final onSetEndDateTime;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.onFavoriteItem,
    required this.onSetStartDateTime,
    required this.onSetEndDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = todo.startDate;
    final endDate = todo.endDate;
    final isEndPending = endDate != null && endDate.isBefore(now);
    final isStartPending = startDate != null && startDate.isBefore(now);
    final isStartToday = startDate != null &&
        startDate.day == now.day &&
        startDate.month == now.month &&
        startDate.year == now.year;
    final isEndToday = endDate != null &&
        endDate.day == now.day &&
        endDate.month == now.month &&
        endDate.year == now.year;

    Color _getChipsColor(bool isStartDate) {
      if (todo.isDone) return const Color.fromARGB(179, 158, 158, 158);
      if (isStartDate? isStartPending : isEndPending) return const Color.fromARGB(255, 209, 38, 26);
      if (isStartDate ? isStartToday : isEndToday)
        return const Color.fromARGB(255, 99, 55, 186);
      else
        return const Color.fromARGB(255, 11, 124, 107);
    }

    String formatDateTime(DateTime? dateTime) {
      if (dateTime == null) return '';
      if (dateTime.day == now.day &&
          dateTime.month == now.month &&
          dateTime.year == now.year) {
        return 'Today at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: todo.isDone
              ? Colors.green
              : const Color.fromARGB(183, 106, 106, 106),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                todo.todoText!,
                style: TextStyle(
                  fontSize: 16,
                  color: todo.isDone
                      ? const Color.fromARGB(198, 113, 113, 113)
                      : tdBlack,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (startDate != null || endDate != null)
              Row(
                children: [
                  if (startDate != null)
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Chip(
                        label: Text(
                          'Start: ${formatDateTime(startDate)}',
                          style:
                              TextStyle(fontSize: 12, color: _getChipsColor(true)),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: _getChipsColor(true)),
                        ),
                      ),
                    ),
                  if (endDate != null)
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Chip(
                        label: Text(
                          ' End: ${formatDateTime(endDate)}',
                          style:
                              TextStyle(fontSize: 12, color: _getChipsColor(false)),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: _getChipsColor(false)),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.star,
                  color: todo.isFavorited ? tdBlack: const Color.fromARGB(162, 158, 158, 158)),
              onPressed: () {
                onFavoriteItem(todo);
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_today, color: const Color.fromARGB(200, 113, 113, 113),),
              onPressed: () async {
                // Select start date and time
                DateTime? startDate = await showDatePicker(
                  helpText: 'Select start date',
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (startDate != null) {
                  TimeOfDay? startTime = await showTimePicker(
                    helpText: 'Select start time',
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (startTime != null) {
                    DateTime startDateTime = DateTime(
                      startDate.year,
                      startDate.month,
                      startDate.day,
                      startTime.hour,
                      startTime.minute,
                    );
                    // Select end date and time
                    DateTime? endDate = await showDatePicker(
                      helpText: 'Select end date',
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (endDate != null) {
                      TimeOfDay? endTime = await showTimePicker(
                        helpText: 'Select end time',
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (endTime != null) {
                        DateTime endDateTime = DateTime(
                          endDate.year,
                          endDate.month,
                          endDate.day,
                          endTime.hour,
                          endTime.minute,
                        );
                        // Update the todo item with the selected start and end date and time
                        print('Start date and time: $startDateTime');
                        print('End date and time: $endDateTime');
                        onSetStartDateTime(todo, startDateTime);
                        onSetEndDateTime(todo, endDateTime);
                        // You need to implement the update logic in your state management
                      }
                    }
                  }
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.close, color: tdGrey),
              onPressed: () {
                onDeleteItem(todo.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
