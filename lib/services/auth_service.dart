import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsapp/models/newsUser_model.dart';
import 'package:newsapp/screens/home_screen.dart';
import 'package:newsapp/screens/login_screen.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future signup(
      String email, String password, String name, BuildContext context) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      Fluttertoast.showToast(
        msg: exception.code.toString(),
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      NewsUser newUser = NewsUser(
        email: email,
        name: name,
        // profilepic: "",
      );
      try {
        newUser.isAdmin = false;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set(newUser.toJson())
            .then((value) {
          Fluttertoast.showToast(
            msg: "Account Created Succesfully",
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
        });
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      }
    }
  }

  Future login(String email, String password, BuildContext context) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      Fluttertoast.showToast(
        msg: exception.code.toString(),
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return;
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      NewsUser loginUser =
          NewsUser.fromJson(userData.data() as Map<String, dynamic>);

      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
      return "Success";
      //kk Navigator.push( context, MaterialPageRoute( builder: (context) => HomePage( chatUser: loginUser, firestoreuser: credential!.user!,)),);
    } else {
      Fluttertoast.showToast(
        msg: "Email/Password is incorrect",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }
}
