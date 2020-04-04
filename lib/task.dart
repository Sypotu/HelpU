import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';




class Task {
  final String id;
  final String title;
  final String description;
  final DocumentReference reference;

  Task.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(reference.documentID != null),
        title = map['title'],
        description = map['description'],
        id = reference.documentID;

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Task<$title>";
}
