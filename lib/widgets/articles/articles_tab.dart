// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../models/article_item_model.dart';
import '../../providers/article_provider.dart';
import '../../general.dart';
import '../../routes.dart';
import '../error.dart';
import '../loading.dart';

class ArticlesTab extends StatefulWidget {
  const ArticlesTab();

  @override
  State<ArticlesTab> createState() => _ArticlesTabState();
}

class _ArticlesTabState extends State<ArticlesTab>
    with AutomaticKeepAliveClientMixin {
  final firestore = FirebaseFirestore.instance;
  final ScrollController scrollController = ScrollController();
  late Future<void> _getItems;
  bool isLastPage = false;
  bool isLoading = false;
  List<ArticleItemModel> _items = [];
  final String collectionName = 'articles';
  void initItem(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    if (!_items.any((element) => element.id == doc.id)) {
      final item = ArticleItemModel(
          id: doc.id,
          date: doc.get('date').toDate(),
          description: doc.get('description'),
          mediaUrl: doc.get('mediaUrl'),
          title: doc.get('title'),
          numViews: 0);
      _items.add(item);
    }
  }

  Future<void> getItems(void Function(List<ArticleItemModel>) setItems) async {
    final itemCollection = firestore.collection(collectionName);
    final getItems =
        await itemCollection.orderBy('date', descending: true).limit(50).get();
    final docs = getItems.docs;
    if (docs.isNotEmpty) {
      for (var doc in docs) {
        initItem(doc);
      }
      setItems(_items);
    }
    if (docs.length < 50) {
      isLastPage = true;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getMoreItems(
      void Function(List<ArticleItemModel>) setItems) async {
    if (!isLoading) {
      isLoading = true;
      setState(() {});
      final collection = firestore.collection(collectionName);
      final lastId = _items.last.id;
      final lastDoc = await collection.doc(lastId).get();
      final next = await collection
          .orderBy('date', descending: true)
          .startAfterDocument(lastDoc)
          .limit(50)
          .get();
      final docs = next.docs;
      if (docs.isNotEmpty) {
        for (var doc in docs) {
          initItem(doc);
        }
        setItems(_items);
      }
      if (docs.length < 50) {
        isLastPage = true;
      }
      isLoading = false;
      setState(() {});
    }
  }

  Widget buildArticleTitle(String title, bool widthQuery) => Text(title,
      style: GoogleFonts.kaiseiDecol(
          textStyle: TextStyle(
              fontSize: widthQuery ? 22.5 : 20,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold)));
  String buildBigDescription(String description) {
    if (description.length > 511) {
      return '${description.substring(0, 510)}...';
    } else {
      return description;
    }
  }

  String buildSmallDescription(String description) {
    if (description.length > 421) {
      return '${description.substring(0, 420)}...';
    } else {
      return description;
    }
  }

  Widget buildDate(DateTime date, String locale, bool widthQuery) {
    return Text(General.timeStamp(date, locale, context),
        style: TextStyle(color: Colors.white, fontSize: widthQuery ? 15 : 14));
  }

  Widget buildArticleDescription(String description, bool widthQuery) => Text(
      widthQuery
          ? buildBigDescription(description)
          : buildSmallDescription(description),
      style: GoogleFonts.nanumGothic(
        textStyle:
            TextStyle(fontSize: widthQuery ? 15.5 : 14.75, color: Colors.black),
      ));

  Widget buildArticleWidget(ArticleItemModel article, bool widthQuery,
      double deviceWidth, String locale) {
    return Container(
      key: ValueKey<String>(article.id),
      height: widthQuery ? 500 : 450,
      width: widthQuery ? 450 : deviceWidth,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      margin: const EdgeInsets.all(8),
      // padding: const EdgeInsets.all(8),
      child: Bounce(
        duration: kThemeAnimationDuration,
        onPressed: () {
          Navigator.pushNamed(context, RouteGenerator.articleScreen,
              arguments: article);
        },
        child: Card(
          surfaceTintColor: Colors.transparent,
          color: Colors.transparent,
          elevation: 5,
          borderOnForeground: false,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(widthQuery ? 20 : 25),
                    gradient: const RadialGradient(
                        radius: 0.35,
                        center: Alignment.bottomRight,
                        stops: [
                          0.75,
                          0.75
                        ],
                        colors: [
                          Colors.black,
                          Colors.white,
                        ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: widthQuery ? 450 : deviceWidth,
                        height: widthQuery ? 70 : 55,
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Center(
                            child:
                                buildArticleTitle(article.title, widthQuery))),
                    // heightBox,
                    Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: buildArticleDescription(
                            article.description, widthQuery)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (article.mediaUrl != '')
                            const Icon(Icons.image_outlined,
                                color: Colors.white, size: 20),
                          if (article.mediaUrl != '') const SizedBox(width: 5),
                          if (article.mediaUrl != '')
                            const Text(
                              '1',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          if (article.mediaUrl != '') const SizedBox(width: 5),
                          const Icon(Icons.visibility_outlined,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            General.optimisedNumbers(article.numViews),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white),
                          ),
                          const Spacer(),
                          buildDate(article.date, locale, widthQuery)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  right: 25,
                  bottom: widthQuery ? 43 : 43,
                  child: SizedBox(
                      height: 49,
                      child: Column(
                        children: [
                          Icon(Icons.arrow_forward,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 30),
                          Text(
                            General.language(context).articles1,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontStyle: FontStyle.italic,
                                fontSize: 13),
                          )
                        ],
                      )))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final setItems =
        Provider.of<ArticleProvider>(context, listen: false).setArticles;
    _getItems = getItems(setItems);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (isLastPage) {
        } else {
          if (!isLoading) {
            getMoreItems(setItems);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(() {});
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool widthQuery = deviceWidth >= 800;

    final langCode = Provider.of<ThemeModel>(context).langCode;
    final setItems =
        Provider.of<ArticleProvider>(context, listen: false).setArticles;
    const emptyBox = SizedBox(width: 0, height: 0);
    const Widget loadingBox = Center(
        child: SizedBox(
            width: 25, height: 25, child: CircularProgressIndicator()));
    super.build(context);
    return FutureBuilder(
        future: _getItems,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (snapshot.hasError) {
            return MyErrorWidget(() {
              setState(() {
                _getItems = getItems(setItems);
              });
            });
          }
          return Builder(builder: (context) {
            // final setItems2 =
            //     Provider.of<ArticleProvider>(context, listen: false)
            //         .setArticles;
            // setItems2(_items);
            return Builder(builder: (context) {
              final List<ArticleItemModel> items =
                  Provider.of<ArticleProvider>(context).articles;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(8),
                      children: [
                        if (widthQuery)
                          Wrap(
                            children: [
                              ...items
                                  .map((e) => buildArticleWidget(
                                      e, widthQuery, deviceWidth, langCode))
                                  .toList()
                            ],
                          ),
                        if (!widthQuery)
                          ...items
                              .map((e) => buildArticleWidget(
                                  e, widthQuery, deviceWidth, langCode))
                              .toList(),
                        if (isLastPage) emptyBox,
                        if (isLoading) loadingBox,
                      ],
                    ),
                  ),
                ],
              );
            });
          });
        });
  }

  @override
  bool get wantKeepAlive => true;
}
