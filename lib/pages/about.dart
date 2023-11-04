import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var jmpfbmx = Uri.parse('https://github.com/jmpfbmx/');
    var notestodo = Uri.parse('https://github.com/flutterprojectsbyj/Notes-ToDo');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            GestureDetector(
              onTap: () => _launchUrl(notestodo),
              child: Image.asset(
                'assets/images/notes_todo.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
          Text(
            "NotesToDo",
            style:GoogleFonts.questrial(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
            const SizedBox(height: 8),
            Text(
              "Version 1.0.0",
              style:GoogleFonts.questrial(
                  color: Colors.white,
                  fontSize: 14,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _launchUrl(jmpfbmx),
              child: Text(
                "© Jose P. (jmpfbmx)",
                style:GoogleFonts.questrial(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: Colors.transparent,
        child: const Icon(Icons.arrow_back, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}