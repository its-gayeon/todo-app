import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:todo_app/utils/todo.dart';

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
