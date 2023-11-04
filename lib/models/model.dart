import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Model extends ChangeNotifier {
  FirebaseFirestore fbStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _isProcessing = false;
  User? _user;
  String _name = "";
  String _str = "";
  List<String> _userInfo = [];
  bool get isProcessing => _isProcessing;
  String get name => _name;
  String get str => _str;
  User? get user => _user;
  List<String> get userInfo => _userInfo;

  processingData(bool process) {
    if(process) {
      _isProcessing = true;
    } else if(!process) {
      _isProcessing = false;
    }
    notifyListeners();
  }

  Future<User?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        hideSnackbar(context);
        showSnackbar(context, "No user found for that email.");
        return null;
      } else if (e.code == 'wrong-password') {
        hideSnackbar(context);
        showSnackbar(context, "Wrong password provided.");
        return null;
      }
    }
    return _user;
  }

  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _name = name;
      _user = userCredential.user;
      await _user!.updateDisplayName(name);
      await _user?.reload();
      _user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        hideSnackbar(context);
        showSnackbar(context, str);
        return null;
      } else if (e.code == 'email-already-in-use') {
        hideSnackbar(context);
        showSnackbar(context, "The account already exists for that email.");
        return null;
      }
    }

    return _user;
  }

  cleanVar() {
    _isProcessing = false;
    _user = null;
    _name = "";
    _str = "";
    _userInfo = [];
  }

  signOut(BuildContext context) async {
    cleanVar();
    await auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
    notifyListeners();
  }

  resetPassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  showSnackbar(BuildContext context, String str, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str, style: const TextStyle(color: Colors.white)),
        backgroundColor: (color != null) ? color : Colors.red
      ),
    );
  }

  hideSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void addUserInfo(String name, String email) async {
    await fbStore.collection("userinfo").doc(email).set({
      "name": name,
      "email": email,
    });
  }

  getUserInfo() async {
    var doc = await fbStore.collection("userinfo").doc(auth.currentUser?.email).get();
    _userInfo.add(doc.data()!["name"]);
    _userInfo.add(doc.data()!["email"]);
    notifyListeners();
    return _userInfo;
  }

  addNote(String title, String content, int colorId) async {
    await fbStore.collection("notes${auth.currentUser?.email}").add({
      "title": title,
      "content": content,
      "colorId": colorId,
      "date": FieldValue.serverTimestamp()
    });
  }

  modifyNote(String docId, String title, String content, int colorId) async {
    await fbStore.collection("notes${auth.currentUser?.email}").doc(docId).update({
      "title": title,
      "content": content,
      "colorId": colorId,
    });
  }

  addTask(String title, List content, List completed, int colorId) async {
    await fbStore.collection("notes${auth.currentUser?.email}").add({
      "title": title,
      "content": content,
      "completed": completed,
      "colorId": colorId,
      "date": FieldValue.serverTimestamp()
    });
  }

  modifyTask(String docId, String title, List content, List completed, int colorId) async {
    await fbStore.collection("notes${auth.currentUser?.email}").doc(docId).update({
      "title": title,
      "content": content,
      "completed": completed,
      "colorId": colorId,
    });
  }
}