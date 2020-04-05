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
import 'flutter_tag/tagging.dart';
import 'flutter_tag/taggable.dart';
import 'flutter_tag/configurations.dart';
import 'package:flutter_typeahead_web/flutter_typeahead.dart';

void main() => runApp(MyApp());

const List<MaterialColor> primaries = <MaterialColor>[
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.blueGrey,
];

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
  List<Tag> _selectedTags;
  @override
  void initState() {
    _selectedTags = [];
    super.initState();
  }

  @override
  void dispose() {
    _selectedTags.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('HelpU'),
          bottom: TabBar(
            //unselectedLabelColor: Colors.indigo,
            //labelColor: Colors.indigo,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                ),
//            indicator: BoxDecoration(
//  //            borderRadius: BorderRadius.circular(50),
//              color: Colors.indigo),
            tabs: [
              Tab(icon: Text("Find a task")),
              Tab(icon: Text("My tasks")),
            ],
          ),
        ),
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
        body: _buildBody(context),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Create'),
          onPressed: () {
            Navigator.pushNamed(context, '/new_task');
          },
          icon: Icon(Icons.add),
          backgroundColor: Colors.indigoAccent,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tags').snapshots(),
      builder: (context, snapshot) {
        print("test finished");
        if (!snapshot.hasData) return LinearProgressIndicator();
        tag_service = TagService(snapshot.data.documents);
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('task')
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            print("test finished2");
            if (!snapshot.hasData) return LinearProgressIndicator();

            return _buildList(context, snapshot.data.documents);
          },
        );
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return TabBarView(
      children: [
        Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: FlutterTagging<Tag>(
              initialItems: _selectedTags,
              enableImmediateSuggestion: true,
              wrapConfiguration: WrapConfiguration(
                runSpacing: 0,
              ),
              suggestionsBoxConfiguration: SuggestionsBoxConfiguration(
                suggestionsBoxVerticalOffset: 0,
                direction: AxisDirection.down,
                //autoFlipDirection: true,
              ),
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                    icon: const Icon(Icons.filter_list),
                    border: InputBorder.none,
                    //filled: true,
                    //fillColor: Colors.grey.withAlpha(30),
                    hintText: 'Search a category',
                    hintStyle:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    labelText: 'Filter',
                    labelStyle: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    )),
              ),
              findSuggestions: tag_service.getTags,
              configureSuggestion: (tag) {
                return SuggestionConfiguration(
                  title: Text(tag.text),
                );
              },
              configureChip: (tag) {
                return ChipConfiguration(
                  label: Text(tag.text),
                  backgroundColor: Colors.amber[800],
                  labelStyle: TextStyle(color: Colors.white),
                  deleteIconColor: Colors.white,
                );
              },
              onChanged: () => [print(_selectedTags), setState(() {})],
            ),
          ),
          Expanded(
            child: ListView(
              //scrollDirection: Axis.vertical,
              //shrinkWrap: true,
              padding: const EdgeInsets.only(top: 2.0),
              children: snapshot
                  .map((data) => _buildListItem(context, data))
                  .toList(),
            ),
          ),
        ]),
        Text("work in progress"),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final task = Task.fromSnapshot(data, tag_service);
    if (_selectedTags.isNotEmpty) {
      for (Tag filter in _selectedTags) {
        if (!task.tags.contains(filter)) {
          return SizedBox();
        }
      }
    }

    var format = DateFormat("EEE MMMM d', at' HH.mm");

    var color =
        primaries[Random(task.id.hashCode).nextInt(primaries.length - 1)];

    return Padding(
      key: ValueKey(task.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Card(
//        decoration: BoxDecoration(
//          border: Border.all(color: Colors.white),
//          borderRadius: BorderRadius.circular(6.0),
//          color: Colors.white,
//        ),
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
                    data: IconThemeData(color: color[600]),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          //color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          IconTheme(
                            data: IconThemeData(color: Colors.grey[600]),
                            child: Icon(Icons.access_time),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 4.0),
                          ),
                          Text(
                            format.format(task.timestamp.toDate()),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              //color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16),
                          IconTheme(
                            data: IconThemeData(color: Colors.grey[600]),
                            child: Icon(Icons.location_on),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 4.0),
                          ),
                          Text(
                            "1.2km away",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              //color: Colors.white,
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
