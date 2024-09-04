import 'package:flutter/material.dart';

class ToDo {
  final int id;
  String task;
  DateTime? date;
  String? description;
  bool isCompleted;
  final int topicId; // Foreign key to the Topic

  ToDo({
    int? id,
    required this.task,
    this.date,
    this.description,
    this.isCompleted = false,
    required this.topicId,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  // helper functions for db
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'date': date,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'topicId': topicId,
    };
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      task: map['task'],
      date: map['date'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      topicId: map['topicId'],
    );
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isBeforeDay(DateTime date1, DateTime date2) {
    return date1.year < date2.year ||
        date1.month < date2.month ||
        date1.day < date2.day;
  }
}

class Topic {
  final int id; // mainly custom id starting from 3
  Color color;
  String name;
  List<ToDo> todos = [];

  Topic({
    int? id,
    this.color = Colors.black,
    required this.name,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  // helper functions for db
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color.value,
      'name': name,
    };
  }

  static Topic fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      color: Color(map['color']),
      name: map['name'],
    );
  }
}
