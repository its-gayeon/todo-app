import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/states/memory_state.dart';
import 'package:todo_app/pages/list_page.dart';

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
    var textTheme = Theme.of(context).textTheme;
    var segBtnTextStyle = TextStyle(
      fontSize: textTheme.labelMedium!.fontSize,
      fontWeight: textTheme.labelMedium!.fontWeight,
    );

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
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)))),
                  segments: <ButtonSegment<ViewType>>[
                    ButtonSegment<ViewType>(
                        value: ViewType.list,
                        label: Text(
                          "List",
                          style: segBtnTextStyle,
                        )),
                    ButtonSegment<ViewType>(
                        value: ViewType.calendar,
                        label: Text(
                          "Calendar",
                          style: segBtnTextStyle,
                        ))
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
