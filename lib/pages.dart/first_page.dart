import 'package:flutter/material.dart';
import 'package:notes_app/backend_work/database.dart';
import 'package:notes_app/pages.dart/list_of_notes.dart';
import 'package:provider/provider.dart';

import 'create_new_note_page.dart';

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DataBase>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'My Dairy',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSizedBox(
                  text: 'Create New Story',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CreateNewNote(
                            database: database,
                          );
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  }),
              SizedBox(
                height: 30,
              ),
              _buildSizedBox(
                text: 'Old Stories',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ListOfNotes(
                        database: database,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizedBox(
      {@required String text, @required VoidCallback onPressed}) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          side: BorderSide.none,
          primary: Colors.orange,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
