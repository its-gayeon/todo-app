import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/databasehelper.dart';
import 'package:todo_app/utils/todo.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();
    // var memoryState = context.watch<MemoryState>();
    // var topics = memoryState.topics;

    return FutureBuilder<List<Topic>>(
      future: _dbHelper.fetchTopics(),
      builder: (context, snapshot) {
        // if its still loading then loading icon
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final topics = snapshot.data!;

        if (topics.isEmpty) {
          return Center(child: AddTopicButton());
        }

        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];

            return ExpansionTile(
              title: Text(
                topic.name,
                style: TextStyle(color: topic.color),
              ),
              children: [
                FutureBuilder<List<ToDo>>(
                  future: _dbHelper.fetchToDosByTopic(topic.id),
                  builder: (context, snapshot) {
                    // if its still loading then loading icon
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final todos = snapshot.data!;

                    // if no todos
                    if (todos.isEmpty) {
                      return const Text("No todos yet!");
                    }

                    return ListView.builder(
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
                                _dbHelper.updateToDo(todo);
                              },
                            ));
                      },
                    );
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}

class AddTopicButton extends StatelessWidget {
  const AddTopicButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final topic =
            Topic(id: DateTime.now().millisecondsSinceEpoch, name: 'New Topic');
      },
    );
  }
}
