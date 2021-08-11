import 'package:flutter/material.dart';
import 'package:notes_app/backend_work/database.dart';
import 'package:notes_app/backend_work/notes_page.dart';
import 'package:notes_app/pages.dart/create_new_note_page.dart';

class ListOfNotes extends StatefulWidget {
  ListOfNotes({@required this.database});
  final DataBase database;
  @override
  _ListOfNotesState createState() => _ListOfNotesState();
}

class _ListOfNotesState extends State<ListOfNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of all the Notes'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Notes>>(
        stream: widget.database.readNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final note = snapshot.data;
            final childeren = note
                .map(
                  (note) => ListTile(
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Text("Edit"),
                              trailing: Icon(Icons.edit),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CreateNewNote(
                                        database: widget.database,
                                        note: note,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: Text("Delete"),
                              trailing: Icon(
                                Icons.delete,
                              ),
                              onTap: () {
                                String id = note.id;

                                return widget.database.delete(id);
                              },
                            ),
                          ),
                        ];
                      },
                    ),
                    title: Text(note.title),
                  ),
                )
                .toList();
            return Center(
                child: ListView.separated(
              itemBuilder: (context, index) {
                return childeren[index];
              },
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[500],
              ),
              itemCount: childeren.length,
            ));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
