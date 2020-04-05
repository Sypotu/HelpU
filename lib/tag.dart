import 'package:cloud_firestore/cloud_firestore.dart';

import 'flutter_tag/taggable.dart';

import 'task.dart';

TagService tag_service;

/// TagService
class TagService {
  List<Tag> tags = [];

  TagService(List<DocumentSnapshot> documents) {
    documents.forEach((f) => [
          tags.add(Tag(reference: f.reference, text: f.data['text'])),
          print(tags),
        ]);
    print("tags");
    print(tags);
  }

  List<Tag> getTags(String query) {
    return tags
        .where((tag) => tag.text.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Tag getTagById(String id) {
    return tags.where((tag) => (tag.reference.documentID == id)).first;
  }

  void addNewTag(String name) async {
    await Firestore.instance.collection('tags').add({
      'text': name,
    });
  }
}

/// Tag Class
class Tag extends Taggable {
  ///
  final String text;
  //final String id;
  final DocumentReference reference;

  /// Creates Tag
  Tag({
    this.reference,
    this.text,
  });

  @override
  List<Object> get props => [text];

  @override
  String toString() => "Tag<$text>";

//  /// Converts the class to json string.
//  String toJson() => '''  {
//    "name": $name,\n
//  }''';
}
