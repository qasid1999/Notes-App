import 'package:flutter/material.dart';

class Notes {
  Notes({@required this.title, @required this.content, @required this.id});
  final String title;
  final String content;
  final String id;
  factory Notes.frommap(Map<String, dynamic> data, String documnetid) {
    String title = data['title'];
    String content = data['content'];
    if (data == null) {
      return null;
    }
    return Notes(
      id: documnetid,
      title: title,
      content: content,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
    };
  }
}
