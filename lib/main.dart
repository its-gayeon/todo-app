import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo_app/pages/list_page.dart';
import 'package:todo_app/utils/databasehelper.dart';
import 'package:todo_app/utils/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MemoryState(),
      child: MaterialApp(
        title: 'ADHD TODO',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const BasePage(),
      ),
    );
  }
}

// db helper functions for state management
class MemoryState extends ChangeNotifier {
  final _dbHelper = DatabaseHelper();

  // in-memory data
  List<Topic> _topics = [];
  List<Topic> get topics => _topics;

  List<ToDo> _todos = [];
  List<ToDo> get todos => _todos;

  void addTopic(Topic topic) {
    _topics.add(topic);
    notifyListeners();
  }

  void addToDo(ToDo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void updateToDo(ToDo todo) {}

  // only to be invoked in the start of the app
  Future<void> fetchTopics() async {
    _topics = await _dbHelper.fetchTopics();
    notifyListeners();
  }

  Future<void> fetchToDosByTopic(int topicId) async {
    _todos = await _dbHelper.fetchToDosByTopic(topicId);
    notifyListeners();
  }
}

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

enum ViewType { list, calendar }

class _BasePageState extends State<BasePage> {
  ViewType selectedViewType = ViewType.list;

  @override
  Widget build(BuildContext context) {
    Widget todoViewPage;
    switch (selectedViewType) {
      case ViewType.list:
        todoViewPage = ListPage();
        break;
      case ViewType.calendar:
        todoViewPage = Text("cal");
        break;
      default:
        throw UnimplementedError('shouldn\'t happen!!');
    }

    var mainArea = ColoredBox(
      color: Colors.white,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: todoViewPage,
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          // "app bar"
          Row(
            children: [
              // button that changes between todo's list <-> calendar view
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SegmentedButton<ViewType>(
                  segments: const <ButtonSegment<ViewType>>[
                    ButtonSegment<ViewType>(
                        value: ViewType.list, label: Text("List")),
                    ButtonSegment<ViewType>(
                        value: ViewType.calendar, label: Text("Calendar"))
                  ],
                  selected: <ViewType>{selectedViewType},
                  onSelectionChanged: (Set<ViewType> type) {
                    setState(() {
                      selectedViewType = type.first;
                    });
                  },
                  showSelectedIcon: false,
                ),
              ),
            ],
          ),
          // sub page that shows the todo stuff
          Expanded(child: mainArea),
        ],
      ),
    );
  }
}
