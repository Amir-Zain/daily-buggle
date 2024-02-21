import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/firebase_options.dart';
import 'package:newsapp/screens/add_article_screen.dart';
import 'package:newsapp/screens/article_screen.dart';
import 'package:newsapp/screens/discover_screen.dart';
import 'package:newsapp/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newsapp/screens/login_screen.dart';
import 'package:newsapp/screens/profile_screen.dart';
import 'package:newsapp/screens/register_screen.dart';
import 'package:newsapp/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  User? firebaseUser = FirebaseAuth.instance.currentUser;
// Define a widget
  bool isLogged;

// Assign widget based on availability of currentUser
  if (firebaseUser != null) {
    isLogged = true;
  } else {
    isLogged = false;
  }
  runApp(MyApp(
    logged: isLogged,
  ));
}

class MyApp extends StatelessWidget {
  final bool logged;
  MyApp({Key? key, required this.logged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Application',
      theme: ThemeData(primarySwatch: Colors.grey, fontFamily: "Nunito"),
      initialRoute: logged ? HomeScreen.routeName : LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        DiscoverScreen.routeName: (context) => const DiscoverScreen(),
        ArticleScreen.routeName: (context) => const ArticleScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        AddArticleScreen.routeName: (context) => const AddArticleScreen(),
      },
    );
  }
}
