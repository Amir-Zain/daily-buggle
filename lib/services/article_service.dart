import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:newsapp/models/article_model.dart';

class ArticleService {
  addArticle(Article article) async {
    await FirebaseFirestore.instance
        .collection("articles")
        .add(article.tojson())
        .then((value) {
      Fluttertoast.showToast(
        msg: "Article Added Succesfully",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    });
  }

  Future<List<Article>> getAllArticles() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('articles');
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    List<Article> allData = querySnapshot.docs
        .map((doc) => Article.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    return allData;
  }
}
