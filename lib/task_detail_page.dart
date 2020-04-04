import 'package:flutter/material.dart';

import 'task.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  TaskDetailPage(this.task);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(task.title),
            Text(task.description),
          ],
        ),
      ),
    );
  }
}
