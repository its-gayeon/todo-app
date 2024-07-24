import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/databasehelper.dart';
import 'package:todo_app/utils/todo.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // DatabaseHelper _dbHelper = DatabaseHelper();
    var memoryState = context.watch<MemoryState>();
    var topics = memoryState.topics;

    Topic tp1 = Topic(id: 0, name: "topic1");
    Topic tp2 = Topic(id: 1, name: "topic2");
    ToDo td1 = ToDo(id: 0, task: "task1", topicId: 0);
    ToDo td2 = ToDo(id: 1, task: "task2", topicId: 1);

    // tp1.todos.add(td1);
    // tp2.todos.add(td2);

    // topics.add(tp1);
    // topics.add(tp2);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AddTopicButton(),
          topics.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    final todos = topic.todos;

                    return ExpansionTile(
                      title: Text(
                        topic.name,
                        style: TextStyle(color: topic.color),
                      ),
                      initiallyExpanded: true,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];
                            return ListTile(
                                title: Text(todo.task),
                                subtitle: todo.description != null
                                    ? Text(todo.description!)
                                    : null,
                                leading: Checkbox(
                                  value: todo.isCompleted,
                                  onChanged: (value) {
                                    todo.isCompleted = value!;
                                    memoryState.updateToDo(todo);
                                  },
                                ));
                          },
                        )
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class AddTopicButton extends StatelessWidget {
  const AddTopicButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      //style: make it minimum size!,
      child: const Icon(Icons.new_label),
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
