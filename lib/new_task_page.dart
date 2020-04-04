import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_tagging/flutter_tagging.dart';

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
  final format = DateFormat("EEEE d MMMM 'at' HH:mm");

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
    // Build a Form widget using the _formKey created above.

    final TagService tag_service = TagService();

    return Scaffold(
      appBar: AppBar(title: Text('COmunity')),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          children: <Widget>[
            new TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.title),
                hintText: 'Enter the task title',
                labelText: 'Title',
              ),
              inputFormatters: [new LengthLimitingTextInputFormatter(30)],
              validator: (val) => val.isEmpty ? 'Title is required' : null,
              //onSaved: (val) => newContact.name = val,
            ),
            new TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.description),
                hintText: 'Enter the task description',
                labelText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              inputFormatters: [new LengthLimitingTextInputFormatter(500)],
              validator: (val) =>
                  val.isEmpty ? 'Description is required' : null,
              //onSaved: (val) => newContact.name = val,
            ),
            new DateTimeField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.access_time),
                hintText: 'Enter the start time',
                labelText: 'Start time',
              ),
              format: format,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: currentValue ?? DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2021));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
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
            new FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.category),
                    labelText: 'Category',
                    errorText: state.hasError ? state.errorText : null,
                  ),
                  isEmpty: _categories == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      value: _category,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          //newContact.favoriteColor = newValue;
                          _category = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _categories.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              validator: (val) {
                return val != '' ? null : 'Please select a category';
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: FlutterTagging<Tag>(
                initialItems: _selectedTags,
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    //icon: const Icon(Icons.category),
                      border: InputBorder.none,
                      //filled: true,
                      //fillColor: Colors.grey.withAlpha(30),
                      hintText: 'Search Tag',
                      labelText: ' + Add Tag',
                      labelStyle: TextStyle(
                          color: Colors.green
                      )
                  ),
//                style: TextStyle(
//                  color: Colors.green,
//                )
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
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                configureChip: (tag) {
                  return ChipConfiguration(
                    label: Text(tag.text),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                    deleteIconColor: Colors.white,
                  );
                },
//              onChanged: () {
//                setState(() {
//                  _selectedValuesJson = _selectedLanguages
//                      .map<String>((lang) => '\n${lang.toJson()}')
//                      .toList()
//                      .toString();
//                  _selectedValuesJson =
//                      _selectedValuesJson.replaceFirst('}]', '}\n]');
//                });
//              },
              ),
            ),
            new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Ask for help'),
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
    );
  }
}

/// TagService
class TagService {

  List<Tag> tags = [];

  TagService() {
    Firestore.instance
        .collection('tags').getDocuments().then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) => tags.add(Tag(id: f.documentID, text: f.data['text'])));
        });
    print("tags");
    print(tags);
  }

  List<Tag> getTags(String query) {
    return tags
        .where((tag) => tag.text.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addNewTag(String name) async {
    await Firestore.instance
        .collection('tags')
        .add({
      'text': name,
    });
  }
}

/// Tag Class
class Tag extends Taggable {
  ///
  final String text;
  final String id;

  /// Creates Tag
  Tag({
    this.id,
    this.text,
  });

  @override
  List<Object> get props => [text];

//  /// Converts the class to json string.
//  String toJson() => '''  {
//    "name": $name,\n
//  }''';
}
