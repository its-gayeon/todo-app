import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/states/memory_state.dart';
import 'package:todo_app/states/selected_state.dart';
import 'package:todo_app/utils/todo.dart';

class CalPage extends StatelessWidget {
  const CalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31));
  }
}
