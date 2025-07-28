// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/blog_item_model.dart';
import '../../models/blog_item_content.dart';
import '../../providers/blog_provider.dart';
import 'blogwidget.dart';
import '../error.dart';
import '../loading.dart';

class BlogTab extends StatefulWidget {
  const BlogTab();

  @override
  State<BlogTab> createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> with AutomaticKeepAliveClientMixin {
  final firestore = FirebaseFirestore.instance;
  final ScrollController scrollController = ScrollController();
  late Future<void> _getItems;
  bool isLastPage = false;
  bool isLoading = false;
  List<BlogItemModel> _items = [];
  final String collectionName = 'blog';
  Future<void> initItem(QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    List<BlogContent> contents = [];
    if (!_items.any((element) => element.id == doc.id)) {
      final getContents = await firestore
          .collection(collectionName)
          .doc(doc.id)
          .collection('contents')
          .orderBy('date', descending: true)
          .get();
      final contentDocs = getContents.docs;
      for (var contentDoc in contentDocs) {
        final content = BlogContent(
            isText: contentDoc.get('isText'),
            mediaIsAsset: false,
            isInEdit: false,
            description: contentDoc.get('description'),
            mediaURL: contentDoc.get('media'),
            thumbnailURL: contentDoc.get('thumbnail'),
            assetPath: '');
        contents.add(content);
      }
      final item = BlogItemModel(
          id: doc.id,
          title: doc.get('title'),
          date: doc.get('date').toDate(),
          views: 0,
          contents: contents);
      _items.add(item);
    }
  }

  Future<void> getItems(void Function(List<BlogItemModel>) setItems) async {
    final itemCollection = firestore.collection(collectionName);
    final getItems =
        await itemCollection.orderBy('date', descending: true).limit(50).get();
    final docs = getItems.docs;
    if (docs.isNotEmpty) {
      for (var doc in docs) {
        await initItem(doc);
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

  Future<void> getMoreItems(void Function(List<BlogItemModel>) setItems) async {
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
          await initItem(doc);
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

  @override
  void initState() {
    super.initState();
    final setItems =
        Provider.of<BlogProvider>(context, listen: false).setBlogItems;
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
    final widthQuery = MediaQuery.of(context).size.width >= 800;
    final setItems =
        Provider.of<BlogProvider>(context, listen: false).setBlogItems;
    const emptyBox = SizedBox(width: 0, height: 0);
    const Widget loadingBox = Center(
        child: SizedBox(
            width: 25, height: 25, child: CircularProgressIndicator()));
    super.build(context);
    return Container(
        color: Colors.white,
        child: FutureBuilder(
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
                //     Provider.of<BlogProvider>(context, listen: false)
                //         .setBlogItems;
                // setItems2(_items);
                return Builder(builder: (context) {
                  final List<BlogItemModel> items =
                      Provider.of<BlogProvider>(context).blogItems;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Stack(children: [
                          ClipPath(
                              clipper: BlackClipper(),
                              child: Container(color: Colors.black)),
                          ListView(
                              padding: const EdgeInsets.all(8),
                              controller: scrollController,
                              children: [
                                if (widthQuery)
                                  Wrap(
                                    children: [
                                      ...items
                                          .map((e) => BlogWidget(e))
                                          .toList()
                                    ],
                                  ),
                                if (!widthQuery)
                                  ...items.map((e) => BlogWidget(e)).toList(),
                                if (isLastPage) emptyBox,
                                if (isLoading) loadingBox,
                              ])
                        ]))
                      ]);
                });
              });
            }));
  }

  @override
  bool get wantKeepAlive => true;
}

class BlackClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 4.25);
    var firstControlPoint = Offset(size.width / 4, size.height / 3);
    var firstEndPoint = Offset(size.width / 2, size.height / 3 - 60);
    var secondControlPoint =
        Offset(size.width - (size.width / 4), size.height / 4 - 65);
    var secondEndPoint = Offset(size.width, size.height / 3 - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
}
