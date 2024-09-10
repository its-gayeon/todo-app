import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:todo_app/utils/todo.dart';

class MemoryState extends ChangeNotifier {
  // //final _dbHelper = DatabaseHelper();

  // in-memory data
  List<Topic> _topics = [];
  List<Topic> get topics => _topics;

  int topiclen = 0;
  int todolen = 0;

  void addTopic(Topic topic) {
    _topics.add(topic);
    topiclen++;
    notifyListeners();
  }

  void addToDo(ToDo todo, int id) {
    topics.firstWhere((element) => element.id == id).todos.add(todo);
    todolen++;
    notifyListeners();
    return;

    // for (Topic topic in _topics) {
    //   if (topic.id == todo.topicId) {
    //     topic.todos.add(todo);
    //     todolen++;
    //     notifyListeners();
    //     return;
    //   }
    // }

    // // should not happen
    // log("Tried to add a todo to unexisting topic");
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

  // iterates through every todos there and make a list of today todos
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

  List<ToDo> getOverToDos() {
    DateTime today = DateTime.now();
    List<ToDo> overToDos = [];

    for (var topic in _topics) {
      for (var todo in topic.todos) {
        if (todo.date != null && ToDo.isBeforeDay(todo.date!, today)) {
          overToDos.add(todo);
        }
      }
    }

    return overToDos;
  }

  // iterates through every todos there and make a list of upcoming todos
  List<ToDo> getUpcomingToDos() {
    DateTime today = DateTime.now();
    List<ToDo> upcomingToDos = [];

    for (var topic in _topics) {
      for (var todo in topic.todos) {
        if (todo.date != null && ToDo.isBeforeDay(today, todo.date!)) {
          upcomingToDos.add(todo);
        }
      }
    }

    return upcomingToDos;
  }

  void toggleCompleted(ToDo todo) {
    todo.isCompleted = !todo.isCompleted;
    notifyListeners();
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
