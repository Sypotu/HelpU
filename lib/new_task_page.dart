import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'flutter_tag/tagging.dart';
import 'flutter_tag/taggable.dart';
import 'flutter_tag/configurations.dart';
import 'package:flutter_typeahead_web/flutter_typeahead.dart';

import 'task.dart';
import 'tag.dart';

// Create a Form widget.
class CreateTaskPage extends StatefulWidget {
  @override
  CreateTaskPageState createState() {
    return CreateTaskPageState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateTaskPageState extends State<CreateTaskPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final List<String> _categories = <String>['', 'delivery', 'social', 'other'];
  String _category = '';
  List<Tag> _selectedTags;
  final format = DateFormat("EEE MMMM d', at' HH.mm");

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

  DateTime selectedTime;
  String selectedDescription;
  String selectedTitle;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    //   final TagService tag_service = TagService();

    return Scaffold(
      appBar: AppBar(title: Text('Create a Task')),
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              SizedBox(height: 20),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.title),
                  hintText: '',
                  labelText: 'Title',
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                validator: (val) => val.isEmpty ? 'Title is required' : null,
                onChanged: (val) => selectedTitle = val,
              ),
              SizedBox(height: 12),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.description),
                  hintText: '',
                  labelText: 'Description',
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                inputFormatters: [new LengthLimitingTextInputFormatter(500)],
                validator: (val) =>
                    val.isEmpty ? 'Description is required' : null,
                onChanged: (val) => selectedDescription = val,
              ),

              SizedBox(height: 12),
              new DateTimeField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.access_time),
                  hintText: '',
                  labelText: 'Starting time',
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                format: format,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2021));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (val) => selectedTime = val,
              ),
//            new Row(children: <Widget>[
//              new Expanded(
//                  child: new TextFormField(
//                decoration: new InputDecoration(
//                  icon: const Icon(Icons.calendar_today),
//                  hintText: 'Enter your date of birth',
//                  labelText: 'Dob',
//                ),
//                //controller: _controller,
//                keyboardType: TextInputType.datetime,
//                //validator: (val) =>
//                //    isValidDob(val) ? null : 'Not a valid date',
//                //onSaved: (val) => newContact.dob = convertToDate(val),
//              )),
//              new IconButton(
//                icon: new Icon(Icons.more_horiz),
//                tooltip: 'Choose date',
//                onPressed: (() {
//               //   _chooseDate(context, _controller.text);
//                }),
//              )
//            ]),
//            new TextFormField(
//              decoration: const InputDecoration(
//                icon: const Icon(Icons.phone),
//                hintText: 'Enter a phone number',
//                labelText: 'Phone',
//              ),
//              keyboardType: TextInputType.phone,
//              inputFormatters: [
//                 new WhitelistingTextInputFormatter(
//                    new RegExp(r'^[()\d -]{1,15}$')),
//              ],
////              validator: (value) => isValidPhoneNumber(value)
////                  ? null
////                  : 'Phone number must be entered as (###)###-####',
////              onSaved: (val) => newContact.phone = val,
//            ),
//            new TextFormField(
//              decoration: const InputDecoration(a
//                icon: const Icon(Icons.email),
//                hintText: 'Enter a email address',
//                labelText: 'Email',
//              ),
//              keyboardType: TextInputType.emailAddress,
////              validator: (value) => isValidEmail(value)
////                  ? null
////                  : 'Please enter a valid email address',
////              onSaved: (val) => newContact.email = val,
//            ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 36.0),
                child: FlutterTagging<Tag>(
                  initialItems: _selectedTags,
                  enableImmediateSuggestion: true,
                  suggestionsBoxConfiguration: SuggestionsBoxConfiguration(
                    suggestionsBoxVerticalOffset: 0,
                    direction: AxisDirection.up,
                    //autoFlipDirection: true,
                  ),
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                        //icon: const Icon(Icons.category),
                        border: InputBorder.none,
                        //filled: true,
                        //fillColor: Colors.grey.withAlpha(30),
                        hintText: 'Type to search a category',
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                        labelText: ' + Add Task Categories',
                        labelStyle: TextStyle(
                          color: Colors.indigoAccent,
                          fontSize: 16,
                        )),
                  ),
                  findSuggestions: tag_service.getTags,
                  additionCallback: (value) {
                    return Tag(
                      text: value,
                    );
                  },
                  onAdded: (tag) {
                    tag_service.addNewTag(tag.text);
                    return tag;
                  },
                  configureSuggestion: (tag) {
                    return SuggestionConfiguration(
                      title: Text(tag.text),
                      additionWidget: Chip(
                        avatar: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                        label: Text('Add New Tag'),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                        backgroundColor: Colors.indigoAccent,
                      ),
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
                ),
              ),

              new Container(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: new RaisedButton(
                    color: Colors.indigoAccent,
                    child: const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Create',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
//                        print(_selectedTags);
//                        print(_selectedTags.map((tag) => tag.reference.documentID));
//                        print(selectedTime);
//                        print(selectedTitle);
//                        print(selectedDescription);
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Sending ...')));
                        sendNewTask(selectedTitle, selectedDescription,
                            selectedTime, _selectedTags, context);
                      }
                    },
                    //                onPressed: _submitForm,
                  )),
            ],
          ),
          // /* child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     TextFormField(
          //       validator: (value) {
          //         if (value.isEmpty) {
          //           return 'Please enter some text';
          //         }
          //         return null;
          //       },
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 16.0),
          //       child: RaisedButton(
          //         onPressed: () {
          //           // Validate returns true if the form is valid, or false
          //           // otherwise.
          //           if (_formKey.currentState.validate()) {
          //             // If the form is valid, display a Snackbar.
          //             Scaffold.of(context).showSnackBar(
          //                 SnackBar(content: Text('Processing Data')));
          //           }
          //         },
          //         child: Text('Submit'),
          //       ),
          //     ),
          //   ],
          // ), */
        ),
      ),
    );
  }
}

void sendNewTask(String title, String description, DateTime time,
    List<Tag> tags, BuildContext context) async {
  print(tags.map((tag) => tag.reference).toList());
  await Firestore.instance.collection('task').add({
    'title': title,
    'description': description,
    'timestamp': time,
    'tags': tags.map((tag) => tag.reference).toList()
  });
  Navigator.pop(context);
}
