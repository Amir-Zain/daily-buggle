import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:newsapp/models/newsUser_model.dart';
import 'package:newsapp/screens/article_screen.dart';
import 'package:newsapp/screens/login_screen.dart';
import 'package:newsapp/services/article_service.dart';
import 'package:newsapp/services/auth_service.dart';
import 'package:newsapp/widgets/bottom_nav_bar.dart';
import 'package:newsapp/widgets/custom_tag.dart';

import '../models/article_model.dart';
import '../widgets/image_container.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = false;
  List<Article> articles = [];
  init() async {
    articles = await ArticleService().getAllArticles();
    setState(() {
      isLoaded = true;
    });
    Logger().e(articles.first.tojson());
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        index: 0,
      ),
      extendBodyBehindAppBar: true,
      body: isLoaded
          ? ListView(
              padding: EdgeInsets.zero,
              children: [
                _MostRecent(article: articles.first),
                const SizedBox(height: 20),
                _BreakingNews(articles: articles)
              ],
            )
          : Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            )),
    );
  }
}

class _BreakingNews extends StatelessWidget {
  const _BreakingNews({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Breaking News',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'More',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length - 1,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, ArticleScreen.routeName,
                            arguments: articles[(index + 1)]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageContainer(
                              width: MediaQuery.of(context).size.width * 0.5,
                              imageUrl: "https://picsum.photos/200/300"),
                          const SizedBox(height: 10),
                          Text(
                            articles[(index + 1)].title.toString(),
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold, height: 1.5),
                          ),
                          const SizedBox(height: 5),
                          Text(
                              '${DateTime.now().difference(articles[(index + 1)].createdAt!).inHours} hours ago',
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 5),
                          Text('by ${articles[(index + 1)].author}',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class _MostRecent extends StatelessWidget {
  const _MostRecent({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      imageUrl: "https://picsum.photos/200/300",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTag(backgroundColor: Colors.grey.withAlpha(150), children: [
            Text(
              'Most Recent',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            )
          ]),
          const SizedBox(height: 10),
          Text(
            article.title!,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold, height: 1.25, color: Colors.white),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ArticleScreen.routeName,
                    arguments: article);
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text(
                    'Learn More',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                  )
                ],
              ))
        ],
      ),
    );
  }
}
