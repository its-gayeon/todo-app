import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
// import 'package:todo_app/utils/databasehelper.dart';
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
    // Topic tp1 = Topic(id: 0, name: "topic1");
    // Topic tp2 = Topic(id: 1, name: "topic2");
    // ToDo td1 = ToDo(id: 0, task: "task1", topicId: 0);
    // ToDo td2 = ToDo(id: 1, task: "task2", topicId: 1);

    // tp1.todos.add(td1);
    // tp2.todos.add(td2);

    // topics.add(tp1);
    // topics.add(tp2);

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 300) {
        return Row(
          children: [
            SizedBox(width: _width, child: ListNavBar()),
            GestureDetector(
              // drag to change the width of the nav bar
              behavior: HitTestBehavior.translucent,
              child: const VerticalDivider(),
              onHorizontalDragUpdate: (details) {
                setState(() {
                  if (_width <= 150 && details.delta.dx < 0) {
                    return; // prevents collapsing
                  }
                  _width += details.delta.dx;
                });
              },
            ),
          ],
        );
      } else {
        return const Placeholder();
      }
    });
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
    var textStyle = TextStyle(
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
            style: textStyle,
          ),
        ),

        // Upcoming
        NavBarTile(
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.indigo,
            size: 20,
          ),
          text: Text(
            "Upcoming",
            style: textStyle,
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(10.0),
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
            style: textStyle,
          ),
        ),

        // scrollable topics
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 2 + 55,
          child: ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return NavBarTile(
                icon: Icon(
                  Icons.circle,
                  size: 20,
                  color: topics[index].color,
                ),
                text: Text(
                  topics[index].name,
                  style: textStyle,
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

class NavBarTile extends StatelessWidget {
  const NavBarTile({super.key, required this.icon, required this.text});

  final Icon icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 6,
      minTileHeight: 20,
      onTap: () {},
      leading: icon,
      title: text,
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
      //style: make it minimum size!,
      child: const Text("+ Add"),
      //style: ButtonStyle(shape: ),
      onPressed: () => _topicDialog(context),
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
