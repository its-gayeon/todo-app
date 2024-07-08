import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/todo.dart';

class ListPage extends StatelessWidget {
  // vvvvv 테스트용 아이템들 추후 삭제
  ToDo td1 =
      ToDo(id: 0, task: "finish the app", description: "flutter practice");
  ToDo td2 = ToDo(id: 1, task: "project sekai", description: "aoyagi touya");

  @override
  Widget build(BuildContext context) {
    var baseState = context.watch<BaseState>();
    var todoList = baseState.todoList;

    // //처음에만 있다가 바로 지우셈 vvvvv 삭제!!
    // todoList.add(td1);
    // todoList.add(td2);

    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, id) {
        final todo = todoList[id];
        return ListTile(
          leading: IconButton(
              icon: todo.isCompleted
                  ? const Icon(Icons.check_box_outline_blank)
                  : const Icon(Icons.check_box),
              onPressed: () {
                // a todo with id done
                baseState.toggleComplete(id);
              }),
          title: Text(todo.task),
        );
      },
    );
  }
}
