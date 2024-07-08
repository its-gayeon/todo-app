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
      create: (context) => BaseState(),
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

class BaseState extends ChangeNotifier {
  // todo stuff saved here
  int gID = 0;

  List<ToDo> todoList = [];

  void addToDo(ToDo item) {
    todoList.add(item);
    notifyListeners();
  }

  void toggleComplete(int id) {
    // flips the state of the isCompleted
    todoList[id].isCompleted = !todoList[id].isCompleted;
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
