import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'flutter_tag/tagging.dart';
import 'flutter_tag/taggable.dart';
import 'flutter_tag/configurations.dart';
import 'package:flutter_typeahead_web/flutter_typeahead.dart';
import 'task.dart';

import 'tag.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  TaskDetailPage(this.task);

  final TagService tag_service = TagService();

  var format = DateFormat("EEE MMMM d', at' HH.mm");

  List<Tag> _selectedTags = [Tag(id: "test", text: "delivery")];

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
          child: Column(
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
              SizedBox(height: 20),

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
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Padding(
                    padding: EdgeInsets.only(right: 4.0),
                  ),
                  Text(
                    "Tegelbacken 22a, Stockholm, Serige",
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
                  Padding(
                    padding: EdgeInsets.only(right: 4.0),
                  ),
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
                  Padding(
                    padding: EdgeInsets.only(right: 4.0),
                  ),
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
                'Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Wrap(
                //  alignment: widget.wrapConfiguration.alignment,
                //     crossAxisAlignment: widget.wrapConfiguration.crossAxisAlignment,
                //     runAlignment: widget.wrapConfiguration.runAlignment,
                //     runSpacing: widget.wrapConfiguration.runSpacing,
                //     spacing: widget.wrapConfiguration.spacing,
                //     direction: widget.wrapConfiguration.direction,
                //     textDirection: widget.wrapConfiguration.textDirection,
                //      verticalDirection: widget.wrapConfiguration.verticalDirection,
                children: _selectedTags.map<Widget>((item) {
                  return Chip(
                    label: Text(item.text),
                    backgroundColor: Colors.amber,
                    labelStyle: TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),

              new Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: new RaisedButton(
                    color: Colors.indigoAccent,
                    child: const Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0),
                      child: Text(
                          'I would like to help :)',

                        style: TextStyle(
                          color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      ),

                    ),
                    onPressed: () {},
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
