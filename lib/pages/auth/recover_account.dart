import 'package:flutter/material.dart';
import 'package:notes_todo/models/model.dart';
import 'package:notes_todo/resources/validator.dart';
import 'package:provider/provider.dart';

class RecoverAccount extends StatelessWidget {
  RecoverAccount({super.key});
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _focusEmail = FocusNode();

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "NotesToDo",
              ),
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                  children: [
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: (value) => Validator.validateEmail(
                        email: value,
                      ),
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(color: Color.fromRGBO(107, 153, 137, 1)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(107, 153, 137, 1)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(166, 206, 231, 1)),
                        ),
                        hintStyle: const TextStyle(color: Color.fromRGBO(137, 200, 188, 1)),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16.0),
                  ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () {
                    _emailTextController.text = "";
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    model.resetPassword(email: _emailTextController.text);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(47, 203, 66, 1),
                    minimumSize: const Size(125, 50),
                  ),
                  child: const Text(
                    'Recover password',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
