import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/states/memory_state.dart';
import 'package:todo_app/states/selected_state.dart';
import 'package:todo_app/utils/todo.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  double _width = 150;

  @override
  Widget build(BuildContext context) {
    // DatabaseHelper _dbHelper = DatabaseHelper();
    var memoryState = context.watch<MemoryState>();
    var topics = memoryState.topics;

    return ChangeNotifierProvider(
      create: (context) => SelectedState(),
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 300) {
          return Row(
            //  [ navbar | context ]
            children: [
              SizedBox(width: _width, child: const ListNavBar()),
              GestureDetector(
                // drag to change the width of the nav bar
                behavior: HitTestBehavior.translucent,
                child: const Padding(
                  padding: EdgeInsets.only(left: 2.0),
                  child: VerticalDivider(endIndent: 8),
                ),
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    if (_width <= 153 && details.delta.dx < 0) {
                      return; // prevents collapsing
                    }
                    _width += details.delta.dx;
                  });
                },
              ),
              Expanded(child: ActualStuff()),
            ],
          );
        } else {
          return const Placeholder();
        }
      }),
    );
  }
}

class ActualStuff extends StatelessWidget {
  const ActualStuff({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var memoryState = context.watch<MemoryState>();
    var topics = memoryState.topics;

    var selectedState = context.watch<SelectedState>();
    var selected = selectedState.selectedTopics;
    selectedState.setTopicLength(topics.length);

    String title = "";

    if (selected.isEmpty) {
      title = "Nothing yet!";
    } else {
      if (selected.contains(NavIDs.all.index)) {
        title = selected.length - 1 == 1
            ? "1 Topic"
            : "${selected.length - 1} Topics";
      } else if (selected.first >= NavIDs.all.index) {
        title = selected.length == 1 ? "1 Topic" : "${selected.length} Topics";
      } else {
        // Today, Upcoming,
        title = NavIDs.values[selected.first].name[0].toUpperCase() +
            NavIDs.values[selected.first].name.substring(1).toLowerCase();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          // title of the page
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: selected.length,
              itemBuilder: (context, index) {
                if (topics.isEmpty) {
                  return Text("No topics yet!");
                }

                // 0: today
                else if (selected[index] == NavIDs.today.index) {
                  List<ToDo> todayToDos = memoryState.getTodayToDos();
                  List<ToDo> overToDos = memoryState.getOverToDos();

                  return Column(
                    children: [
                      // overdue
                      overToDos.isEmpty
                          ? const SizedBox()
                          : TopicTile(
                              topic: Topic(name: "Overdue", color: Colors.red),
                              children: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: overToDos.length,
                                itemBuilder: (context, todoIndex) {
                                  int currTopicID = overToDos.first.topicId;
                                  if (todoIndex + 1 < overToDos.length &&
                                      currTopicID !=
                                          overToDos[todoIndex + 1].topicId) {
                                    currTopicID =
                                        overToDos[todoIndex + 1].topicId;
                                  }
                                  return ToDoTile(overToDos[todoIndex],
                                      color: topics
                                          .firstWhere((element) =>
                                              element.id == currTopicID)
                                          .color);
                                },
                              ),
                            ),

                      // today
                      todayToDos.isEmpty
                          ? const SizedBox()
                          : TopicTile(
                              topic: Topic(name: "Today", color: Colors.yellow),
                              children: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: todayToDos.length,
                                itemBuilder: (context, todoIndex) {
                                  int currTopicID = todayToDos.first.topicId;
                                  if (todoIndex + 1 < todayToDos.length &&
                                      currTopicID !=
                                          todayToDos[todoIndex + 1].topicId) {
                                    currTopicID =
                                        todayToDos[todoIndex + 1].topicId;
                                  }
                                  return ToDoTile(todayToDos[todoIndex],
                                      color: topics
                                          .firstWhere((element) =>
                                              element.id == currTopicID)
                                          .color);
                                },
                              ),
                            )
                    ],
                  );
                }

                // 1: upcoming
                else if (selected[index] == NavIDs.upcoming.index) {
                  List<ToDo> upcomingToDos = memoryState.getUpcomingToDos();
                  if (upcomingToDos.isEmpty) {
                    return Text("No Upcoming ToDos!");
                  }

                  return TopicTile(
                    topic: Topic(name: "Upcoming", color: Colors.blue),
                    children: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: upcomingToDos.length,
                      itemBuilder: (context, todoIndex) {
                        int currTopicID = upcomingToDos.first.topicId;
                        if (todoIndex + 1 < upcomingToDos.length &&
                            currTopicID !=
                                upcomingToDos[todoIndex + 1].topicId) {
                          currTopicID = upcomingToDos[todoIndex + 1].topicId;
                        }
                        return ToDoTile(upcomingToDos[todoIndex]);
                      },
                    ),
                  );
                }

                // 2: All
                else if (selected[index] == NavIDs.all.index) {
                  return const SizedBox(); // "continue"
                }

                // 3: topics
                // TODO: check topic's existence before assigning to currTopic
                final currTopic = topics[selected[index] - NavIDs.topic0.index];

                return TopicTile(
                  topic: currTopic,
                  children: ListView.builder(
                      shrinkWrap: true,
                      // padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      itemCount: currTopic.todos.length,
                      itemBuilder: (context, todoIndex) {
                        return ToDoTile(
                          currTopic.todos[todoIndex],
                          color: currTopic.color,
                        );
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TopicTile extends StatelessWidget {
  TopicTile({
    super.key,
    required this.topic,
    required this.children,
  });

  final Topic topic;
  final Widget children;
  final taskTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    var memoryState = context.watch<MemoryState>();

    return Theme(
      data: ThemeData(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 4.0),
        child: ExpansionTile(
            expansionAnimationStyle: AnimationStyle(
                curve: Curves.easeInOut, duration: Durations.short4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            backgroundColor: Colors.white,
            initiallyExpanded: true,
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            minTileHeight: 20,
            enableFeedback: false,
            iconColor: topic.color,
            collapsedIconColor: topic.color,
            collapsedBackgroundColor: Colors.white,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              topic.name,
              style: textTheme.labelLarge,
            ),
            childrenPadding: EdgeInsets.zero,
            children: [
              const Divider(
                height: 1,
                thickness: 1,
                indent: 8.0,
                endIndent: 8.0,
                color: Colors.black26,
              ),
              children,
              ListTile(
                minTileHeight: 10,
                contentPadding: const EdgeInsets.only(left: 45, right: 12),
                leading: Icon(
                  Icons.add,
                  color: topic.color.withAlpha(180),
                ),
                title: TextField(
                    cursorHeight: 15,
                    style: textTheme.bodyMedium,
                    decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: "Add task",
                        hintStyle: TextStyle(
                            fontSize: textTheme.bodyMedium!.fontSize,
                            fontWeight: textTheme.bodyMedium!.fontWeight,
                            color: Colors.black54)),
                    controller: taskTextFieldController,
                    onSubmitted: (value) {
                      memoryState.addToDo(
                          ToDo(task: value, topicId: topic.id), topic.id);
                      taskTextFieldController.clear();
                    }),
              ),
            ]),
      ),
    );
  }
}

class ToDoTile extends StatelessWidget {
  const ToDoTile(
    this.currToDo, {
    this.color = Colors.black,
    super.key,
  });

  final ToDo currToDo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var memoryState = context.watch<MemoryState>();
    var textTheme = Theme.of(context).textTheme;
    var editTask = false;

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return ListTile(
          minTileHeight: 10,
          contentPadding: const EdgeInsets.only(left: 45, right: 12),
          leading: GestureDetector(
            onTap: () {
              memoryState.toggleCompleted(currToDo);
            },
            child: Icon(
              currToDo.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: color.withAlpha(180),
            ),
          ),
          title: GestureDetector(
            // TODO: add drag and stuff maybe?
            child: TextField(
              cursorHeight: 15,
              style: textTheme.bodyMedium,
              controller: TextEditingController()..text = currToDo.task,
              onSubmitted: (text) {
                memoryState.updateToDo(ToDo(
                    task: text, topicId: currToDo.topicId, id: currToDo.id));
                editTask = false;
              },
              decoration: const InputDecoration(
                  isDense: true, border: InputBorder.none),
            ),
          ),
        );
      },
    );
  }
}

// custom navigation bar for listpage
class ListNavBar extends StatelessWidget {
  const ListNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var memoryState = context.watch<MemoryState>();
    var topics = memoryState.topics;

    var textTheme = Theme.of(context).textTheme;
    var navTileTextStyle = TextStyle(
      fontSize: textTheme.labelMedium!.fontSize,
      fontWeight: textTheme.labelMedium!.fontWeight,
    );

    return Column(
      children: <Widget>[
        // Today
        NavBarTile(
            icon: const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
            text: Text(
              "Today",
              style: navTileTextStyle,
            ),
            id: NavIDs.today.index),

        // Upcoming
        NavBarTile(
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.indigo,
            size: 20,
          ),
          text: Text(
            "Upcoming",
            style: navTileTextStyle,
          ),
          id: NavIDs.upcoming.index,
        ),

        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
          child: Divider(),
        ),

        // All
        NavBarTile(
          icon: const Icon(
            Icons.toc,
            color: Colors.black54,
            size: 20,
          ),
          text: Text(
            "All",
            style: navTileTextStyle,
          ),
          id: NavIDs.all.index,
        ),

        // scrollable topics
        Expanded(
          child: ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return NavBarTile(
                id: index + NavIDs.topic0.index,
                icon: Icon(
                  Icons.circle,
                  size: 20,
                  color: topics[index].color,
                ),
                text: Text(
                  topics[index].name,
                  style: navTileTextStyle,
                ),
              );
            },
          ),
        ),

        // buttons for adding and searching topics
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [AddTopicButton()],
        )
      ],
    );
  }
}

// customed ListTile for the "navigation bar"
class NavBarTile extends StatelessWidget {
  const NavBarTile({
    super.key,
    required this.icon,
    required this.text,
    required this.id,
  });

  final Icon icon;
  final Text text;
  final int id;

  @override
  Widget build(BuildContext context) {
    var sectionState = context.watch<SelectedState>();
    var sections = sectionState.selectedTopics;

    var memoryState = context.watch<MemoryState>();
    var topics = memoryState.topics;

    var todoCount;
    if (id == NavIDs.today.index) {
      todoCount = memoryState.getTodayToDos().length +
          memoryState.getOverToDos().length;
    } else if (id == NavIDs.upcoming.index) {
      todoCount = memoryState.getUpcomingToDos().length;
    } else if (id == NavIDs.all.index) {
      todoCount = memoryState.todolen;
    } else {
      todoCount = -1;
      // this shouldn't happen
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListTile(
        horizontalTitleGap: 6,
        selectedTileColor: const Color.fromARGB(14, 0, 0, 0),
        minTileHeight: 20,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        selectedColor: Colors.black54,
        selected: sections.contains(id) ? true : false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        onTap: () {
          // switch the list to only show the selected topics
          sectionState.toggleSection(id);
        },
        onLongPress: () {
          // and/or right click
          // TODO: change the name / color of the topic
        },
        leading: id < NavIDs.topic0.index || sections.contains(id)
            ? icon // star, calendar, or filled circle for the selected topics
            : Icon(Icons.circle_outlined,
                color: icon.color,
                size: icon.size), // not selected topic's icon
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text,
            Text(
              "${id >= NavIDs.topic0.index ? topics.firstWhere((element) => element.id == id - NavIDs.topic0.index).todos.length : todoCount}",
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.search,
          size: 20,
        ));
  }
}

class AddTopicButton extends StatelessWidget {
  const AddTopicButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextButton(
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)))),
        onPressed: () => _topicDialog(context),
        child: Text(
          "+ New Topic",
          style: TextStyle(
              fontSize: textTheme.labelMedium!.fontSize,
              fontWeight: textTheme.labelMedium!.fontWeight),
        ),
      ),
    );
  }

  Future<void> _topicDialog(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Color> colorScheme = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.black,
    ];

    String? topicName;
    Color topicColor = Colors.black;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SimpleDialog(
              elevation: 0,
              title: const Text("Add New Topic"),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
              titleTextStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              ),
              children: [
                SizedBox(
                  width: 100,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        TextField(
                            autofocus: true,
                            cursorHeight: 15,
                            style: textTheme.bodySmall,
                            decoration: InputDecoration(
                                labelText: "Topic's name",
                                labelStyle: TextStyle(
                                    fontSize: textTheme.bodySmall!.fontSize,
                                    fontWeight: textTheme.bodySmall!.fontWeight,
                                    color: Colors.black54)),
                            onChanged: (value) {
                              setState(() {
                                topicName = value;
                              });
                            }),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Color: ",
                                  style: textTheme.bodySmall,
                                ),
                                DropdownButton(
                                    //TODO: need to customize!!!!! (actually make a separate widget file)
                                    items: colorScheme
                                        .map((element) => DropdownMenuItem(
                                            value: element,
                                            child: Icon(
                                              Icons.circle,
                                              color: element,
                                            )))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() => topicColor = value!);
                                    }),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              if (topicName != null) {
                                log("adding!");
                                var memoryState = context.read<MemoryState>();
                                memoryState.addTopic(Topic(
                                    id: memoryState.topiclen,
                                    name: topicName!,
                                    color: topicColor));
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text("OK", style: textTheme.labelSmall),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
