// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import '../../general.dart';
import '../../models/gallery_item_model.dart';
import '../../models/screen_arguments.dart';
import '../../providers/gallery_provider.dart';
import '../../providers/theme_provider.dart';
import '../../routes.dart';
import '../error.dart';
import '../loading.dart';

class GalleryTab extends StatefulWidget {
  const GalleryTab();

  @override
  State<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab>
    with AutomaticKeepAliveClientMixin {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final ScrollController scrollController = ScrollController();
  late Future<void> _getItems;
  bool isLastPage = false;
  bool isLoading = false;
  List<GalleryItemModel> _items = [];
  final String collectionName = 'gallery';
  void initItem(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    if (!_items.any((element) => element.id == doc.id)) {
      final item = GalleryItemModel(
          id: doc.id,
          url: doc.get('url'),
          thumbnail: doc.get('thumbnail'),
          date: doc.get('date').toDate(),
          views: 0);
      _items.add(item);
    }
  }

  Future<void> getItems(void Function(List<GalleryItemModel>) setItems) async {
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
      void Function(List<GalleryItemModel>) setItems) async {
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

  Widget buildDateText(DateTime date, String locale, bool widthQuery) {
    return Stack(children: <Widget>[
      Text(General.timeStamp(date, locale, context),
          style: TextStyle(
              fontSize: widthQuery ? 15 : 12,
              shadows: const [
                Shadow(color: Colors.black, blurRadius: 20),
                Shadow(color: Colors.black, blurRadius: 20)
              ],
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = widthQuery ? 2.5 : 3
                ..color = Colors.black)),
      Text(General.timeStamp(date, locale, context),
          style: TextStyle(color: Colors.white, fontSize: widthQuery ? 15 : 12))
    ]);
  }

  Widget buildGalleryItemWidget(GalleryItemModel item, bool isEditing,
      bool widthQuery, String locale, List<String> urls, int currentIndex) {
    final reference = storage.refFromURL(item.url);
    final fullPath = reference.fullPath;
    final type = lookupMimeType(fullPath);
    final isImage = type!.startsWith('image');
    return Bounce(
        duration: kThemeAnimationDuration,
        onPressed: () {
          final args =
              MediaScreenArgs(mediaUrls: urls, currentIndex: currentIndex);
          Navigator.pushNamed(context, RouteGenerator.mediaScreen,
              arguments: args);
        },
        child: Container(
            height: widthQuery ? 300 : 150,
            width: widthQuery ? 300 : 150,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ExtendedImage.network(item.thumbnail,
                          fit: BoxFit.cover),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          margin: const EdgeInsets.only(right: 8, bottom: 8),
                          child: buildDateText(item.date, locale, widthQuery)),
                    ),
                    if (isEditing)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.cancel, color: Colors.red)),
                      ),
                    if (!isImage)
                      Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.play_circle_fill,
                            color: Theme.of(context).colorScheme.secondary,
                            size: widthQuery ? 60 : 45),
                      )
                  ],
                ))));
  }

  Widget buildAddMediaWidget(bool widthQuery) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          height: widthQuery ? 300 : 150,
          width: widthQuery ? 300 : 150,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(15)),
          child: const Center(
              child:
                  Icon(Icons.add_box_outlined, color: Colors.white, size: 25))),
    );
  }

  @override
  void initState() {
    super.initState();
    final setItems =
        Provider.of<GalleryProvider>(context, listen: false).setGalleryItems;
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
    bool isEditing = Provider.of<GalleryProvider>(context).isEditing;
    final bool widthQuery = MediaQuery.of(context).size.width >= 800;
    final langCode = Provider.of<ThemeModel>(context).langCode;
    final setItems =
        Provider.of<GalleryProvider>(context, listen: false).setGalleryItems;
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
            //     Provider.of<GalleryProvider>(context, listen: false)
            //         .setGalleryItems;
            // setItems2(_items);
            return Builder(builder: (context) {
              final List<GalleryItemModel> items =
                  Provider.of<GalleryProvider>(context).galleryItems;
              final List<String> urls = items.map((e) => e.url).toList();
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
                      Wrap(children: [
                        ...items.map((e) {
                          final currentIndex = items.indexOf(e);
                          return buildGalleryItemWidget(e, isEditing,
                              widthQuery, langCode, urls, currentIndex);
                        }).toList(),
                        if (isEditing) buildAddMediaWidget(widthQuery)
                      ]),
                      if (isLastPage) emptyBox,
                      if (isLoading) loadingBox,
                    ],
                  )),
                ],
              );
            });
          });
        });
  }

  @override
  bool get wantKeepAlive => true;
}
