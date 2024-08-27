import 'dart:developer';

import 'package:flutter/material.dart';
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

    // Topic tp1 = Topic(id: 3, name: "topic1");
    // Topic tp2 = Topic(id: 4, name: "topic2");
    // ToDo td1 = ToDo(id: 0, task: "task1", topicId: 0);
    // ToDo td2 = ToDo(id: 1, task: "task2", topicId: 1);

    // tp1.todos.add(td1);
    // tp2.todos.add(td2);

    // topics.add(tp1);
    // topics.add(tp2);

    return ChangeNotifierProvider(
      create: (context) => SelectedState(),
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 300) {
          return Row(
            //  [ navigation bar | context ]
            children: [
              SizedBox(width: _width, child: const ListNavBar()),
              GestureDetector(
                // drag to change the width of the nav bar
                behavior: HitTestBehavior.translucent,
                child: const Padding(
                  padding: EdgeInsets.only(left: 4.0),
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
    var memoryState = context.watch<MemoryState>();
    var topics = memoryState.topics;

    var selectedState = context.watch<SelectedState>();
    var selected = selectedState.selectedSection;
    // selectedState.setTopicLength(2);

    String title = "";

    if (selected.isEmpty) {
      title = "Nothing yet!";
    } else {
      if (selected.first >= NavIDs.all.index) {
        title = selected.first == NavIDs.all.index
            ? "${selected.length - 1} topics"
            : "${selected.length} topics";
      } else {
        title = NavIDs.values[selected.first].name;
      }
    }

    return Column(
      children: [
        Text(title),
        // ListView.builder(
        //   itemCount: topics.length,
        //   itemBuilder: (context, index) {},
        // ),
      ],
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
            id: 0),

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
          id: 1,
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
          id: 2,
        ),

        // scrollable topics
        Expanded(
          child: ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return NavBarTile(
                id: index + 3,
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
          children: [AddTopicButton(), SearchButton()],
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
    var state = context.watch<SelectedState>();
    var sections = state.selectedSection;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListTile(
        horizontalTitleGap: 6,
        selectedTileColor: const Color.fromARGB(14, 0, 0, 0),
        minTileHeight: 20,
        selected: sections.contains(id) ? true : false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        onTap: () {
          // switch the list to only show the selected topics
          state.toggleSection(id);
          //log('$id is ${sections.contains(id)}');
        },
        onLongPress: () {
          // TODO: change the name / color of the topic
        },
        leading: id < 3 || sections.contains(id)
            ? icon
            : Icon(Icons.circle_outlined, color: icon.color, size: icon.size),
        title: text,
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
    return IconButton(onPressed: () {}, icon: const Icon(Icons.search));
  }
}

class AddTopicButton extends StatelessWidget {
  const AddTopicButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)))),
      onPressed: () => _topicDialog(context),
      //style: make it minimum size!,
      child: const Text("+ Add"),
    );
  }

  Future<void> _topicDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Add New Topic"),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
          titleTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
          children: const [
            Column(children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(),
              ),
            ]),
          ],
        );
      },
    );
  }
}
