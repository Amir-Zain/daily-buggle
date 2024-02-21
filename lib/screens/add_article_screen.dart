import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:newsapp/models/article_model.dart';
import 'package:newsapp/models/newsUser_model.dart';
import 'package:newsapp/screens/login_screen.dart';
import 'package:newsapp/services/article_service.dart';
import 'package:newsapp/services/auth_service.dart';
import 'package:newsapp/widgets/bottom_nav_bar.dart';
import 'package:newsapp/widgets/my_button.dart';
import 'package:newsapp/widgets/my_textfield.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  static const routeName = '/add-article';
  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  // Initial Selected Value
  String dropdownvalue = 'Health';

  // List of items in our dropdown menu
  var items = [
    'Health',
    'Politics',
    'Art',
    'Food',
    'Science',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            AuthService().signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          },
          icon: const Icon(
            Icons.logout_rounded,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        index: 3,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text('Add Article',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: titleController,
                  hintText: "Title",
                  obscureText: false),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: authorController,
                  hintText: "Author",
                  obscureText: false),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField2(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    //Add isDense true and zero Padding.
                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    //Add more decoration as you want here
                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                  ),
                  isExpanded: true,
                  hint: const Text(
                    'Select Category',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    dropdownvalue = value.toString();
                  },
                  buttonStyleData: ButtonStyleData(
                      height: 60,
                      padding: EdgeInsets.only(left: 20, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      )),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: bodyController,
                  hintText: "Body",
                  lines: 4,
                  obscureText: false),
              SizedBox(
                height: 30,
              ),
              MyButton(
                  onTap: () {
                    Article article = Article();
                    article.title = titleController.text;
                    // article.title = "title2 testing";
                    article.body = bodyController.text;
                    // article.body = "body2 testing";
                    article.category = dropdownvalue;
                    article.author = authorController.text;
                    // article.author = "author2 testing";
                    article.createdAt = DateTime.now();
                    ArticleService().addArticle(article);
                  },
                  text: "Save")
            ],
          ),
        ),
      ),
    );
  }
}
