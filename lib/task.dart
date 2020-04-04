import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tag.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final Timestamp timestamp;
  final DocumentReference reference;
  List<Tag> tags;

  Task.fromMap(Map<String, dynamic> map, this.reference, TagService tag_service)
      : assert(map['title'] != null),
        assert(reference.documentID != null),
        title = map['title'],
        description = map['description'],
        timestamp = map['timestamp'],
        id = reference.documentID {
    print("test");
    tags=[];
    List<dynamic> entitlements = map["tags"];
    entitlements.forEach((entitlement) {
      if (entitlement is DocumentReference) {
        print(entitlement.documentID);
       // tag_service.getTagById(entitlement.documentID);
      }else{
        print("strange");
      }
      print(entitlement);
      //print(entitlement.documentID);
    });
//    List<DocumentReference> tags = map["tags"];
//    print(tags.map((item) => item.documentID));
  }

  Task.fromSnapshot(DocumentSnapshot snapshot, TagService tag_ser)
      : this.fromMap(snapshot.data, snapshot.reference, tag_ser);

  @override
  String toString() => "Task<$title>";
}
