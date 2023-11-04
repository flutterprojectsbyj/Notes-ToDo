import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_todo/models/model.dart';
import 'package:notes_todo/pages/about.dart';
import 'package:notes_todo/pages/notes/notes_creator.dart';
import 'package:notes_todo/pages/notes/notes_editor.dart';
import 'package:notes_todo/pages/notes/todo_creator.dart';
import 'package:notes_todo/pages/notes/todo_editor.dart';
import 'package:notes_todo/widgets/custom_modal_bottom_sheet.dart';
import 'package:notes_todo/widgets/note_card.dart';
import 'package:provider/provider.dart';

import 'package:notes_todo/widgets/modal_bottom_list_item.dart';
import 'package:notes_todo/widgets/todo_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesToDo extends StatefulWidget {
  const NotesToDo({super.key});

  @override
  State<NotesToDo> createState() => _NotesToDoState();
}

class _NotesToDoState extends State<NotesToDo> {
  bool showNoteAsGridView = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      showNoteAsGridView = prefs.getBool('showNoteAsGridView') ?? false;
    });
  }

  _savePreferences() {
    prefs.setBool('showNoteAsGridView', showNoteAsGridView);
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("NotesToDo"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showNoteAsGridView = !showNoteAsGridView;
              });
              _savePreferences();
            },
            icon: Icon((showNoteAsGridView) ? Icons.view_agenda_outlined : Icons.grid_view),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          shrinkWrap: true,
          controller: ScrollController(),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          bool result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Are you sure you want to exit from NotesToDo?"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    model.signOut;
                    if (Platform.isIOS) {
                      exit(0);
                    } else if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text("Yes"),
                ),
              ],
            ),
          );
          return result;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0,),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("notes${model.auth.currentUser?.email}").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (showNoteAsGridView) ? 2 : 1),
                      children: snapshot.data!.docs.map((note) =>
                        (note["content"] is String) ? Dismissible(
                          key: Key(note.id),
                          onDismissed: (direction) async {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text('Are you sure you want to delete this note?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() { });
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      model.deleteNoteToDo(note.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Item deleted")),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: noteCard(() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return NotesEditor(doc: note);
                                }
                              )
                            );
                          }, note),
                        ) : Dismissible(
                          key: Key(note.id),
                          onDismissed: (direction) async {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text('Are you sure you want to delete this To-Do?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() { });
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      model.deleteNoteToDo(note.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Item deleted")),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: todoCard(() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ToDoEditor(doc: note);
                                }
                              )
                            );
                          }, note, showNoteAsGridView),
                        )).toList(),
                    );
                  }
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return CustomBottomSheet(
               listChild: [
                 ModalBottomListItem(
                     leading: const Icon(Icons.note),
                     title: const Text(
                       'Add Note',
                       style: TextStyle(
                           fontSize: 14
                       ),
                     ),
                     onPressed: () {
                       Navigator.of(context).push(
                         MaterialPageRoute(
                           builder: (context) {
                             return const NotesCreator();
                           }
                         )
                       );
                     }
                 ),
                 ModalBottomListItem(
                     leading: const Icon(Icons.list),
                     title: const Text(
                       'Add TODO List',
                       style: TextStyle(
                           fontSize: 14
                       ),
                     ),
                     onPressed: () {
                       Navigator.of(context).push(
                         MaterialPageRoute(
                           builder: (context) {
                             return const ToDoCreator();
                           }
                         )
                       );
                     }
                 ),
               ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add
        ),
      ),
    );
  }
}