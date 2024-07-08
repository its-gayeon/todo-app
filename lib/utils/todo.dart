import 'package:flutter/material.dart';

class ToDo {
  final int id;
  String task;
  Tag? tag;
  String? description;
  bool isCompleted;

  ToDo({
    required this.id,
    required this.task,
    this.tag,
    this.description,
    this.isCompleted = false,
  });
}

class Tag {
  Color color;
  String name;

  Tag({
    this.color = Colors.black,
    required this.name,
  });
}
