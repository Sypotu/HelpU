import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  TaskDetailPage(this.task);

  var format = DateFormat("EEE MMMM d', at' HH.mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: SafeArea(
        bottom: true,
        left: true,
        right: true,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child:      Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),

              ),
              SizedBox(height: 10),


              Row(
                children: <Widget>[
                  Icon(Icons.access_time),
                  Padding(padding: EdgeInsets.only(right: 4.0),),
                  Text(
                    format.format(task.timestamp.toDate()),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize:16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Padding(padding: EdgeInsets.only(right: 4.0),),
                  Text(
                    "Tegelbacken 22a, Stockholm, Serige",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize:16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),

              ),
              SizedBox(height: 10),



              Text(
                task.description,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 24),

              Text(
                'Poster',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),

              ),
              SizedBox(height: 10),

// Profile images here

              Row(
                children: <Widget>[
                  Icon(Icons.person),
                  Padding(padding: EdgeInsets.only(right: 4.0),),
                  Text(
                    "Anna Bella",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Icon(Icons.phone_iphone),
                  Padding(padding: EdgeInsets.only(right: 4.0),),
                  Text(
                    "+46 767891221",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),
              Text(
                'Tags',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),

              ),
              new Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: new RaisedButton(
                    child: const Text('I want to help'),
                    //                onPressed: _submitForm,
                  )),

            ],
          ),
        ),




      ),
    );
  }
}
