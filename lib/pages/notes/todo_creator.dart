import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_todo/models/model.dart';
import 'package:notes_todo/pages/notes_todo.dart';
import 'package:notes_todo/style/card_style.dart';
import 'package:provider/provider.dart';

class ToDoCreator extends StatefulWidget {
  const ToDoCreator({super.key});

  @override
  State<ToDoCreator> createState() => _ToDoCreatorState();
}

class _ToDoCreatorState extends State<ToDoCreator> {
  final _titleTextController = TextEditingController();
  final _contentTextControllerList = [TextEditingController()];
  List<bool> _completedList = [false];
  FocusNode _lastFocusNode = FocusNode();
  int colorId = Random().nextInt(CardStyle.cardColors.length + 1);

  @override
  void initState() {
    super.initState();
    _lastFocusNode.addListener(_handleLastTextFieldFocus);
  }

  void _handleLastTextFieldFocus() {
    if (_lastFocusNode.hasFocus) {
      final newFocusNode = FocusNode();
      _contentTextControllerList.add(TextEditingController());
      _completedList.add(false);
      _lastFocusNode.removeListener(_handleLastTextFieldFocus);
      _lastFocusNode = newFocusNode;
      _lastFocusNode.addListener(_handleLastTextFieldFocus);

      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      backgroundColor: CardStyle.cardColors[colorId],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if(_titleTextController.text.isNotEmpty || _contentTextControllerList.where((e) => e.text.isNotEmpty).map((e) => e.text).toList().isNotEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Discard your new To-Do list?'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Your new To-Do list will be lost if you discard it.'),
                        SizedBox(height: 10),
                        Text('Do you want to discard your To-Do List?'),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Discard'),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => const NotesToDo(),
                            ),
                                (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(Icons.arrow_back_outlined, color: CardStyle.getTextColorForBackground(CardStyle.cardColors[colorId])),
        ),
        backgroundColor: CardStyle.cardColors[colorId],
        elevation: 0.0,
        title: TextField(
          controller: _titleTextController,
          style: CardStyle.title.copyWith(color: CardStyle.getTextColorForBackground(CardStyle.cardColors[colorId])),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'To-Do List title',
            hintStyle: CardStyle.title.copyWith(color: CardStyle.getTextColorForBackground(CardStyle.cardColors[colorId])),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("dd/MM/yyy HH:mm a").format((DateTime.now())).toString(),
                style: CardStyle.date.copyWith(color: CardStyle.getTextColorForBackground(CardStyle.cardColors[colorId])),
              ),
              const SizedBox(height: 6.0,),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _contentTextControllerList.length,
                  itemBuilder: (context, index) {
                    return ListTileTheme(
                      contentPadding: const EdgeInsets.all(0), // Remove all padding
                      dense: true,
                      horizontalTitleGap: 0.0,
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        onChanged: (bool? value) {
                          _completedList[index] = value!;
                          setState(() {});
                        },
                        value: _completedList[index],
                        checkColor: Colors.white,
                        activeColor: Colors.green,
                        side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                              width: 1.0,
                              color: CardStyle.getTextColorForBackground(CardStyle.cardColors[colorId])
                          ),
                        ),
                        title: TextField(
                          controller: _contentTextControllerList[index],
                          focusNode: (_contentTextControllerList[index] == _contentTextControllerList.last) ? _lastFocusNode : null,
                          style: CardStyle.content.copyWith(color: CardStyle.getTextColorForBackground(CardStyle.cardColors[colorId]), decoration: (_completedList[index]) ? TextDecoration.lineThrough : TextDecoration.none),
                          onTapOutside: ((event) {
                            FocusScope.of(context).unfocus();
                          }),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Task To-Do',
                            hintStyle: CardStyle.content.copyWith(color: CardStyle.getTextColorForBackground(CardStyle.cardColors[colorId])),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'bgColor',
            backgroundColor: Colors.black,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pick a Color'),
                    content: SizedBox(
                      width: double.maxFinite,
                      height: 150,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                        ),
                        itemCount: CardStyle.cardColors.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              colorId = index;
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: CardStyle.cardColors[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(
                Icons.palette_outlined,
                color: Colors.white
            ),
          ),
          const SizedBox(width: 4,),
          FloatingActionButton(
            heroTag: 'save',
            backgroundColor: Colors.black,
            onPressed: () {
              List content =  _contentTextControllerList.where((e) => e.text.isNotEmpty).map((e) => e.text).toList();
              List completed = _completedList;
              if (content.length < completed.length) { completed.removeLast(); }
              model.addTask(_titleTextController.text, content, completed, colorId);
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
