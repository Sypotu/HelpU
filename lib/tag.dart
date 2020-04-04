import 'package:cloud_firestore/cloud_firestore.dart';

import 'flutter_tag/taggable.dart';

import 'task.dart';


/// TagService
class TagService {
  List<Tag> tags = [];

  TagService() {
    Firestore.instance
        .collection('tags')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach(
        (f) => tags.add(Tag(id: f.documentID, text: f.data['text'])),
      );
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
    await Firestore.instance.collection('tags').add({
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

  @override
  String toString() => "Tag<$text>";

//  /// Converts the class to json string.
//  String toJson() => '''  {
//    "name": $name,\n
//  }''';
}
