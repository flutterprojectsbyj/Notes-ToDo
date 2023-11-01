import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_todo/models/model.dart';
import 'package:notes_todo/pages/notes/notes_editor.dart';
import 'package:notes_todo/widgets/custom_modal_bottom_sheet.dart';
import 'package:notes_todo/widgets/note_card.dart';
import 'package:provider/provider.dart';

import '../widgets/modal_bottom_list_item.dart';

class NotesToDo extends StatefulWidget {
  const NotesToDo({super.key});

  @override
  State<NotesToDo> createState() => _NotesToDoState();
}

class _NotesToDoState extends State<NotesToDo> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("NotesToDo"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {  },
            icon: const Icon(Icons.view_agenda_outlined), // Icons.grid_view
          ),
        ],
        automaticallyImplyLeading: false,
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
            const Text(
              "Your recent Notes",
            ),
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      children: snapshot.data!.docs.map((note) => noteCard(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return NotesEditor(doc: note);
                            }
                          )
                        ); 
                      }, note)).toList(),
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
                     onPressed: () { }
                 ),
                 ModalBottomListItem(
                     leading: const Icon(Icons.list),
                     title: const Text(
                       'Add TODO List',
                       style: TextStyle(
                           fontSize: 14
                       ),
                     ),
                     onPressed: () { }
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