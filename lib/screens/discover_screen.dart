import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:newsapp/screens/article_screen.dart';
import 'package:newsapp/screens/login_screen.dart';
import 'package:newsapp/services/article_service.dart';
import 'package:newsapp/services/auth_service.dart';
import 'package:newsapp/widgets/image_container.dart';

import '../models/article_model.dart';
import '../widgets/bottom_nav_bar.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  static const routeName = '/discover';

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool isLoaded = false;

  List<Article> articles = [];

  init() async {
    articles = await ArticleService().getAllArticles();
    setState(() {
      isLoaded = true;
    });
    articles.where((item) => item.category == "Health").toList();
    Logger().e(articles.first.tojson());
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [
      Tab(
        child: Text(
          "Health",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Tab(
        child: Text(
          "Politics",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Tab(
        child: Text(
          "Art",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Tab(
        child: Text(
          "Food",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      Tab(
        child: Text(
          "Science",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
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
        bottomNavigationBar: BottomNavBar(index: 1),
        body: isLoaded
            ? ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  const _DiscoverNews(),
                  _CategoryNews(
                    tabs: tabs,
                    articles: articles,
                  )
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _CategoryNews extends StatefulWidget {
  _CategoryNews({
    Key? key,
    required this.tabs,
    required this.articles,
  }) : super(key: key);

  final List<Tab> tabs;
  final List<Article> articles;

  @override
  State<_CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<_CategoryNews> {
  List<Article> healthArticles = [];

  List<Article> artArticles = [];

  List<Article> politicsArticles = [];

  List<Article> foodArticles = [];

  List<Article> scienceArticles = [];
  @override
  void initState() {
    for (var element in widget.articles) {
      switch (element.category) {
        case "Health":
          healthArticles.add(element);
          break;
        case "Politics":
          politicsArticles.add(element);
          break;
        case "Art":
          artArticles.add(element);
          break;
        case "Food":
          foodArticles.add(element);
          break;
        case "Science":
          scienceArticles.add(element);
          break;
        default:
      }
    }
    super.initState();
  }

  List<Article> filteredNews = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs: widget.tabs),
        SizedBox(
          // height: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          // width: 300,
          child: TabBarView(children: [
            ArticleItem(filteredNews: healthArticles),
            ArticleItem(filteredNews: politicsArticles),
            ArticleItem(filteredNews: artArticles),
            ArticleItem(filteredNews: foodArticles),
            ArticleItem(filteredNews: scienceArticles),
          ]),
        )
      ],
    );
  }
}

class ArticleItem extends StatelessWidget {
  const ArticleItem({
    Key? key,
    required this.filteredNews,
  }) : super(key: key);

  final List<Article> filteredNews;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredNews.length,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context, ArticleScreen.routeName,
                // arguments: articles[index]
              );
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Row(
                children: [
                  ImageContainer(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.all(10.0),
                      borderRadius: 5,
                      imageUrl: "https://picsum.photos/200/300"),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          filteredNews[index].title!,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${DateTime.now().difference(filteredNews[index].createdAt!).inHours} hours ago',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DiscoverNews extends StatelessWidget {
  const _DiscoverNews({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Discover',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('News from all over the world',
              style: Theme.of(context).textTheme.bodySmall),
          // const SizedBox(height: 20),
          // TextFormField(
          //   decoration: InputDecoration(
          //       hintText: 'Search',
          //       fillColor: Colors.grey.shade200,
          //       filled: true,
          //       prefixIcon: const Icon(Icons.search, color: Colors.grey),
          //       suffixIcon: const RotatedBox(
          //           quarterTurns: 1,
          //           child: Icon(Icons.tune, color: Colors.grey)),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(20.0),
          //         borderSide: BorderSide.none,
          //       )),
          // )
        ],
      ),
    );
  }
}
