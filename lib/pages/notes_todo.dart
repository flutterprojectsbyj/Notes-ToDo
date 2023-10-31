import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_todo/models/model.dart';
import 'package:notes_todo/widgets/custom_modal_bottom_sheet.dart';
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
        child: const Column(
          children: [

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