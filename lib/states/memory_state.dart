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

  // iterates through every todos there and
  List<ToDo> getTodayToDos() {
    DateTime today = DateTime.now();
    List<ToDo> todayToDos = [];

    for (var topic in _topics) {
      for (var todo in topic.todos) {
        if (todo.date != null && ToDo.isSameDay(today, todo.date!)) {
          todayToDos.add(todo);
        }
      }
    }

    return todayToDos;
  }

  List<ToDo> getUpcomingToDos() {
    DateTime today = DateTime.now();
    List<ToDo> upcomingToDos = [];

    for (var topic in _topics) {
      for (var todo in topic.todos) {
        if (todo.date != null && todo.date!.isAfter(today)) {
          upcomingToDos.add(todo);
        }
      }
    }

    return upcomingToDos;
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
