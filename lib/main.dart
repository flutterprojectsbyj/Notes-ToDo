import 'package:notes_todo/libraries.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_todo/models/model.dart';
import 'package:notes_todo/pages/auth_page.dart';
import 'package:notes_todo/resources/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (context) => Model(),
      builder: (context, child) {
        return Init(savedThemeMode: savedThemeMode);
      }
  )
  );
}

class Init extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const Init({super.key, required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            titleTextStyle: TextStyle(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
          ),
          brightness: Brightness.light,
          primaryColor: Colors.black,
          hintColor: Colors.amber,
          scaffoldBackgroundColor: Colors.white,
          drawerTheme: const DrawerThemeData(
              backgroundColor: Colors.white
          ),
          listTileTheme: const ListTileThemeData(
            textColor: Colors.black,
            iconColor: Colors.black,
          )
      ),
      dark: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          hintColor: Colors.amber,
          scaffoldBackgroundColor: Colors.black,
          drawerTheme: const DrawerThemeData(
              backgroundColor: Colors.black
          ),
          listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
            iconColor: Colors.white,
          ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: LoginRegister(savedThemeMode: savedThemeMode),
      ),
    );
  }
}