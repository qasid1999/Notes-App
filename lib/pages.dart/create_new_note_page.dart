import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/backend_work/database.dart';
import 'package:notes_app/backend_work/notes_page.dart';

class CreateNewNote extends StatefulWidget {
  CreateNewNote({@required this.database, this.note});
  final DataBase database;
  final Notes note;
  @override
  _CreateNewNoteState createState() => _CreateNewNoteState();
}

class _CreateNewNoteState extends State<CreateNewNote> {
  String _title;
  String _content;

  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note.title;
      _content = widget.note.content;
    }
  }

  bool _validatethenote() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    String idBydate() => DateTime.now().toIso8601String();

    if (_validatethenote()) {
      try {
        final notes = await widget.database.readNotes().first;
        final allnotestitle = notes.map((note) => note.title).toList();
        if (widget.note != null) {
          allnotestitle.remove(widget.note.title);
        }
        if (allnotestitle.contains(_title)) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('The Title $_title is already taken'),
                content: Text('Please choose a different Tile Name.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          final id = widget.note?.id ?? idBydate();
          final note = Notes(
            id: id,
            title: _title,
            content: _content,
          );
          await widget.database.creatNote(note);
        }
      } on FirebaseException catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Operation Failed'),
              content: Text(e.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.note == null ? 'Create New Story' : 'Eddit Story'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.system_update_tv_sharp,
              color: Colors.teal[300],
            ),
            onPressed: () {
              _submit();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: buildFormCard(),
      ),
    );
  }

  Widget buildFormCard() {
    return Card(
      shadowColor: Colors.white,
      elevation: 20,
      child: Form(
          key: _formkey,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange[200],

                    /* border: Border(
                bottom: BorderSide(color: Colors.orange, width: 5),
              ),*/
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.orange[500],
                        width: 5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextFormField(
                      initialValue: _title,
                      validator: (value) =>
                          value.isNotEmpty ? null : 'Title Can not be empty',
                      decoration: InputDecoration(
                        hintText: 'title',
                        border: InputBorder.none,
                      ),
                      onSaved: (value) => _title = value,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[100],

                      /* border: Border(
                bottom: BorderSide(color: Colors.orange, width: 5),
              ),*/
                      border: Border(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextFormField(
                        maxLines: null,
                        initialValue: _content,
                        validator: (value) => value.isNotEmpty
                            ? null
                            : 'Content Can not be empty',
                        decoration: InputDecoration(
                          hintText: 'Content',
                          border: InputBorder.none,
                        ),
                        onSaved: (value) => _content = value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
