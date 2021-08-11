import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/backend_work/api_path.dart';

import 'notes_page.dart';

abstract class DataBase {
  Future<void> creatNote(Notes note);
  Stream<List<Notes>> readNotes();
  delete(String id);
}

class FirestoreDataBase extends DataBase {
  //FirestoreDataBase({@required this.uid}) : assert(uid != null);
  String idBydate() => DateTime.now().toIso8601String();
  //final String uid;

  @override
  Future<void> creatNote(Notes note) async {
    final path = API_Path.note(note.id);
    final docreference = FirebaseFirestore.instance.doc(path);
    await docreference.set(note.toMap());
  }

  @override
  Stream<List<Notes>> readNotes() {
    final path = API_Path.notePath();
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshot = reference.snapshots();
    return snapshot.map((snapshot) => snapshot.docs.map((snapshot) {
          final data = snapshot.data();
          return Notes.frommap(data, snapshot.id);
        }).toList());
  }

  Stream<List<T>> collectionStream<T>(
      {@required
          String path,
      @required
          T Function(Map<String, dynamic> data, String documnetid) builder}) {
    final path = API_Path.notePath();
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshot = reference.snapshots();
    return snapshot.map((snapshot) =>
        snapshot.docs.map((snapshot) => builder(snapshot.data(), snapshot.id)));
  }

  @override
  delete(String id) async {
    String documentPath = "/user/$id";
    FirebaseFirestore instance = FirebaseFirestore.instance;
    await instance.doc(documentPath).delete();
  }
}
