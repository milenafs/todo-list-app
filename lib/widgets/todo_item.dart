import 'dart:ffi';

import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../utils/utils.dart';

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
    final isFavorited = todo.isFavorited;
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
      if (isStartDate ? isStartPending : isEndPending)
        return const Color.fromARGB(255, 209, 38, 26);
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
      String month = monthName(dateTime.month);

      return '$month ${dateTime.day}${dateTime.year != now.year ? ', ${dateTime.year}' : ''}';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: todo.isDone
              ? Colors.green
              : const Color.fromARGB(183, 106, 106, 106),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (todo.isFavorited) // Verifique se o todo está favoritado
                  Icon(
                    Icons.star,
                    color: const Color.fromARGB(255, 193, 165, 6),
                  ),
                SizedBox(width: 8), // Espaço entre o ícone e o texto
                Flexible(
                  child: Text(
                    todo.todoText!,
                    style: TextStyle(
                      fontSize: 16,
                      color: todo.isDone
                          ? const Color.fromARGB(198, 113, 113, 113)
                          : tdBlack,
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                    overflow: TextOverflow.visible, // Ensure text wraps
                  ),
                ),
              ],
            ),
            if (startDate != null || endDate != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (startDate != null)
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Chip(
                          label: Row(
                            children: [
                              Icon(Icons.flag_outlined,
                                  size: 16, color: _getChipsColor(true)),
                              SizedBox(width: 4),
                              Text(
                                'Start: ${formatDateTime(startDate)}',
                                style: TextStyle(
                                    fontSize: 12, color: _getChipsColor(true)),
                              ),
                            ],
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
                          label: Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 16, color: _getChipsColor(false)),
                              SizedBox(width: 4),
                              Text(
                                'End: ${formatDateTime(endDate)}',
                                style: TextStyle(
                                    fontSize: 12, color: _getChipsColor(false)),
                              ),
                            ],
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: _getChipsColor(false)),
                          ),
                        ),
                      ),
                  ],
                ),
              )
          ],
        ),
        trailing: Padding(
          padding: EdgeInsets.all(0), // Ajuste os valores conforme necessário
          child: PopupMenuButton<int>(
            icon: Icon(Icons.more_vert,
                color: const Color.fromARGB(159, 58, 58, 58), size: 20),
            onSelected: (int result) async {
              switch (result) {
                case 0:
                  onFavoriteItem(todo);
                  break;
                case 1:
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
                  break;
                case 2:
                  onDeleteItem(todo.id);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  leading: Icon(Icons.star,
                      color: todo.isFavorited
                          ? const Color.fromARGB(255, 255, 217, 0)
                          : const Color.fromARGB(162, 158, 158, 158)),
                  title: Text('Favorite'),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.calendar_today,
                      color: const Color.fromARGB(200, 113, 113, 113)),
                  title: Text('Set Date & Time'),
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.delete, color: tdGrey),
                  title: Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
