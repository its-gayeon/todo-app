import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/pages/list_page.dart';
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
        title: 'TODO on Desk',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const BasePage(),
      ),
    );
  }
}

// db helper functions for state management
class MemoryState extends ChangeNotifier {
  // //final _dbHelper = DatabaseHelper();

  // in-memory data
  List<Topic> _topics = [];
  List<Topic> get topics => _topics;

  void addTopic(Topic topic) {
    _topics.add(topic);
    notifyListeners();
  }

  void addToDo(ToDo todo) {
    for (Topic topic in _topics) {
      if (topic.id == todo.topicId) {
        topic.todos.add(todo);
        notifyListeners();
        return;
      }
    }

    // should not happen
    log("Tried to add a todo to unexisting topic");
  }

  void updateToDo(ToDo todo) {
    for (Topic topic in _topics) {
      if (topic.id == todo.topicId) {
        topic.todos.add(todo);
        notifyListeners();
        return;
      }
    }
  }

  // // only to be invoked in the start of the app
  // Future<void> fetchTopics() async {
  //   _topics = await _dbHelper.fetchTopics();
  //   notifyListeners();
  // }

  // Future<void> fetchToDosByTopic(int topicId) async {
  //   _todos = await _dbHelper.fetchToDosByTopic(topicId);
  //   notifyListeners();
  // }
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
        todoViewPage = const ListPage();
        break;
      case ViewType.calendar:
        todoViewPage = const Text("cal");
        break;
      default:
        throw UnimplementedError('shouldn\'t happen!!');
    }

    var mainArea = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: todoViewPage,
    );

    // var mainArea = PageView(
    //   children: [ListPage(), Text("cal")],
    // );

    return Scaffold(
      body: Column(
        children: [
          //page controller
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: SegmentedButton<ViewType>(
                  segments: const <ButtonSegment<ViewType>>[
                    ButtonSegment<ViewType>(
                        value: ViewType.list,
                        label: Icon(Icons.list) /*Text("List")*/),
                    ButtonSegment<ViewType>(
                        value: ViewType.calendar,
                        label: Icon(Icons.calendar_today) /*Text("Calendar")*/)
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
            ),
          ),
          const Divider(
            thickness: 1.3,
          ),
          // sub page that shows the todo stuff
          Expanded(child: mainArea),
        ],
      ),
    );
  }
}
