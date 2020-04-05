import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack/profile_tab.dart';
import 'package:intl/intl.dart';
import 'new_task_page.dart';
import 'task.dart';
import 'tag.dart';
import 'task_detail_page.dart';
import 'dart:math';
import 'package:flutter_typeahead_web/flutter_typeahead.dart';
import 'profile_tab.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelpU',
      theme: ThemeData(
        // Use the green theme for Material widgets.
        primarySwatch: Colors.indigo,
      ),
      //darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/task_detail': (context) =>
            TaskDetailPage(ModalRoute.of(context).settings.arguments),
        '/new_task': (context) => CreateTaskPage(),
        '/profile': (context) => ProfileTab(),
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
      appBar: AppBar(title: Text('HelpU')),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image(
                image: AssetImage("assets/logo1.png"),
              ),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: //Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//        TypeAheadField(
////          textFieldConfiguration: TextFieldConfiguration(
////              autofocus: true,
//////              style: DefaultTextStyle.of(context).style.copyWith(
//////                  fontStyle: FontStyle.italic
//////              ),
////              decoration: InputDecoration(
////                  border: OutlineInputBorder()
////              )
////          ),
//          suggestionsCallback: (pattern) async {
//  //          return await BackendService.getSuggestions(pattern);
//          },
//          itemBuilder: (context, suggestion) {
//            return ListTile(
//              leading: Icon(Icons.shopping_cart),
//              title: Text(suggestion['name']),
//              subtitle: Text('\$${suggestion['price']}'),
//            );
//          },
//          onSuggestionSelected: (suggestion) {
//            Navigator.of(context).push(MaterialPageRoute(
//     //           builder: (context) => ProductPage(product: suggestion)
//            ));
//          },
//        ),
          _buildBody(context),
      //]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new_task');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('tags')
          .snapshots(),
      builder: (context, snapshot) {
        print("test finished");
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        tag_service = TagService(snapshot.data.documents);
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('task')
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            print("test finished2");
            if (!snapshot.hasData)
              return LinearProgressIndicator();

            return _buildList(context, snapshot.data.documents);
          },
        );
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
    final task = Task.fromSnapshot(data, tag_service);

    var format = DateFormat("EEE MMMM d', at' HH.mm");

    var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    return Padding(
      key: ValueKey(task.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16.0),
          color: color.withOpacity(0.2),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/task_detail',
              arguments: task,
            );
          },
          child: Container(
            padding: EdgeInsets.all(12.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  IconTheme(
                    data: IconThemeData(color: color),
                    child: Icon(Icons.person_pin, size: 52),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6.0),
                      ),
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Icon(Icons.access_time),
                          Padding(
                            padding: EdgeInsets.only(right: 4.0),
                          ),
                          Text(
                            format.format(task.timestamp.toDate()),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.location_on),
                          Padding(
                            padding: EdgeInsets.only(right: 4.0),
                          ),
                          Text(
                            "1.2km away",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
            ]),
          ),
        ),
//        child: ListTile(
//            title: Text(task.title),
//            //trailing: Text(task.vote.toString()),
//            //onTap: () => task.reference.updateData({'vote': FieldValue.increment(1)}),
//            onTap: () {
//              Navigator.pushNamed(
//                context,
//                '/task_detail',
//                arguments: task,
//              );
//            }),
      ),
    );
  }
}
