import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:newsapp/models/newsUser_model.dart';
import 'package:newsapp/screens/add_article_screen.dart';
import 'package:newsapp/screens/profile_screen.dart';

import '../screens/article_screen.dart';
import '../screens/discover_screen.dart';
import '../screens/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isAdmin = false;

  init() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .get();
      NewsUser loginUser =
          NewsUser.fromJson(userData.data() as Map<String, dynamic>);

      setState(() {
        isAdmin = loginUser.isAdmin!;
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withAlpha(100),
      items: [
        BottomNavigationBarItem(
            icon: Container(
                margin: const EdgeInsets.only(left: 50),
                child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    },
                    icon: const Icon(Icons.home))),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, DiscoverScreen.routeName);
                },
                icon: const Icon(Icons.search)),
            label: 'Search'),
        BottomNavigationBarItem(
            icon: Container(
                margin: const EdgeInsets.only(right: 50),
                child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                    icon: const Icon(Icons.person))),
            label: 'Profile'),
        if (isAdmin) ...[
          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AddArticleScreen.routeName);
                  },
                  icon: const Icon(Icons.add)),
              label: 'Add'),
        ]
      ],
    );
  }
}
