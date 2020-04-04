import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COmunity',
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/task_detail': (context) => TaskDetailPage(ModalRoute.of(context).settings.arguments),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('COmunity')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('task').orderBy('vote',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final task = Task.fromSnapshot(data);

    return Padding(
      key: ValueKey(task.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(task.title),
          trailing: Text(task.vote.toString()),
          //onTap: () => task.reference.updateData({'vote': FieldValue.increment(1)}),
          //onTap: () => task.reference.updateData({'vote': FieldValue.increment(1)}),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/task_detail',
              arguments: task,
            );
          }
        ),
      ),
    );
  }
}

class TaskDetailPage extends StatelessWidget {
  final Task task;

  TaskDetailPage (this.task);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final int vote;
  final DocumentReference reference;

  Task.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['vote'] != null),
        assert(reference.documentID != null),
        title = map['title'],
        vote = map['vote'],
        id = reference.documentID;

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Task<$title:$vote>";
}