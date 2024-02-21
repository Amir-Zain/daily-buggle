import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:newsapp/services/auth_service.dart';
import '../models/newsUser_model.dart';
import '../widgets/rounded_image.dart';
import 'login_screen.dart';

/// Contain information about current user profile

class ProfileScreen extends StatefulWidget {
  final NewsUser profile = NewsUser();

  static const routeName = '/profile';
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  NewsUser user = NewsUser();

  String? profileText;
  getData() async {
    User? loggedUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: loggedUser!.email)
        .get()
        .then((value) {
      setState(() {
        user = NewsUser.fromJson(value.docs.first.data());
      });
      Logger().e(user.email);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Button that logout user
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            user.email != null ? profileBody() : Container(),
          ],
        ),
      ),
    );
  }

  Widget profileBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Profile",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Name"),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(user.name!),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email"),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(user.email!),
              ),
            ],
          ),
        ),

        const SizedBox(height: 35),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: () async {
              AuthService().signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (Route<dynamic> route) => false);
            },
            style: ElevatedButton.styleFrom(
              elevation: 8,
              // backgroundColor: AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // <-- Radius
              ),
            ),
            child: Text(
              'Log out',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        )
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 20),
        //   child: Text(
        //     profileText!,
        //     style: const TextStyle(fontSize: 15),
        //   ),
        // ),
      ],
    );
  }
}
