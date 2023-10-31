import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_todo/models/model.dart';
import 'package:notes_todo/pages/auth/recover_account.dart';
import 'package:notes_todo/pages/notes_todo.dart';
import 'package:notes_todo/resources/validator.dart';
import 'package:provider/provider.dart';
import 'package:notes_todo/libraries.dart';

class Login extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  Login({super.key, required this.savedThemeMode});
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    final form = _formKey.currentState;
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
                  TextFormField(
                    controller: _passwordTextController,
                    focusNode: _focusPassword,
                    obscureText: true,
                    validator: (value) => Validator.validatePassword(
                      password: value,
                      register: false,
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
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
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () {
                    _emailTextController.text = "";
                    _passwordTextController.text = "";
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    _focusEmail.unfocus();
                    _focusPassword.unfocus();

                    if (form != null && form.validate()) {
                      model.processingData(true);
                    }

                    User? user = await model.signIn(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                      context: context,
                    );

                    model.processingData(false);

                    if (_emailTextController.text.isNotEmpty && _passwordTextController.text.isNotEmpty && user != null) {
                      _emailTextController.clear();
                      _passwordTextController.clear();
                      navigator.push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const NotesToDo();
                          },
                        ),
                      );
                      model.getUserInfo();
                      user = null;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(47, 203, 66, 1),
                    minimumSize: const Size(125, 50),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            TextButton(
              child: const Text("Don't you remember your password?", style: TextStyle(color: Color.fromRGBO(164, 201, 238, 1))),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return RecoverAccount();
                    }
                  )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
