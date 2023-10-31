import 'package:notes_todo/libraries.dart';
import 'package:notes_todo/pages/auth/login.dart';
import 'package:notes_todo/pages/auth/register.dart';
import 'package:flutter/material.dart';

class LoginRegister extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const LoginRegister({super.key, required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Center(
            child: Text(
              "NotesToDo",
            ),
          ),
          const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Login(savedThemeMode: savedThemeMode);
                    }
                  )
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(47, 203, 66, 1),
                minimumSize: const Size(125, 50),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Register();
                    }
                  )
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(64, 151, 117, 1),
                minimumSize: const Size(125, 50),
              ),
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.black),
              ),
            ),
        ]),
      ),
    );
  }
}