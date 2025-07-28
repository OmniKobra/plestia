// ignore_for_file: use_key_in_widget_constructors

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../general.dart';
import 'package:mime/mime.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/blog_item_content.dart';
import '../../models/blog_item_model.dart';
import '../../models/screen_arguments.dart';
import '../../providers/home_provider.dart';
import '../../providers/theme_provider.dart';
import '../../routes.dart';

class BlogWidget extends StatefulWidget {
  final BlogItemModel blogItem;
  const BlogWidget(this.blogItem);

  @override
  State<BlogWidget> createState() => _BlogWidgetState();
}

class _BlogWidgetState extends State<BlogWidget> {
  final storage = FirebaseStorage.instance;
  Widget buildTextField(String description, bool widthQuery) {
    String shownDescription = description;
    // if (description.length > 300) {
    //   shownDescription = '${description.substring(0, 300)}...';
    // }
    return Container(
        padding: const EdgeInsets.all(8),
        child: Text(shownDescription,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: widthQuery ? 15 : 13)));
  }

  Widget buildMediaItem(String url, String thumbnailUrl, bool widthQuery) {
    final reference = storage.refFromURL(url);
    final fullPath = reference.fullPath;
    final type = lookupMimeType(fullPath);
    final isImage = type!.startsWith('image');
    return GestureDetector(
        onTap: () {
          final args = MediaScreenArgs(mediaUrls: [url], currentIndex: 0);
          Navigator.pushNamed(context, RouteGenerator.mediaScreen,
              arguments: args);
        },
        child: Container(
            height: widthQuery ? 220 : 170,
            width: widthQuery ? 220 : 170,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(children: [
                  Center(
                    child:
                        ExtendedImage.network(thumbnailUrl, fit: BoxFit.cover),
                  ),
                  if (!isImage)
                    Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.play_circle_fill,
                          color: Theme.of(context).colorScheme.secondary,
                          size: widthQuery ? 45 : 35),
                    )
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final locale = theme.langCode;
    final textDirection = theme.textDirection;
    final deviceWidth = MediaQuery.of(context).size.width;
    final widthQuery = deviceWidth >= 800;
    final List<BlogContent> items = widget.blogItem.contents;
    final date = widget.blogItem.date;
    final String name = Provider.of<HomeProvider>(context).name;
    final String avatarUrl = Provider.of<HomeProvider>(context).avatarUrl;
    return ClipRRect(
      key: ValueKey<String>(widget.blogItem.id),
      borderRadius: BorderRadius.circular(15),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 10,
            maxHeight: 5000,
            minWidth: 10,
            maxWidth: widthQuery ? 500 : deviceWidth),
        child: Card(
          elevation: 5,
          surfaceTintColor: Colors.white,
          margin:
              widthQuery ? const EdgeInsets.all(10) : const EdgeInsets.all(5),
          borderOnForeground: false,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Directionality(
                    textDirection: textDirection,
                    child: ListTile(
                        isThreeLine: true,
                        contentPadding: widthQuery
                            ? const EdgeInsets.all(0)
                            : EdgeInsets.only(
                                left:
                                    textDirection == TextDirection.rtl ? 0 : 8,
                                right:
                                    textDirection == TextDirection.rtl ? 8 : 0),
                        horizontalTitleGap: widthQuery ? 5.0 : 10,
                        leading: CircleAvatar(
                            radius: widthQuery ? 30 : 20,
                            backgroundColor: Colors.grey.shade100,
                            backgroundImage: NetworkImage(avatarUrl)),
                        title: Text(name,
                            style: TextStyle(
                                fontSize: widthQuery ? 18 : 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${widget.blogItem.title}\n${General.timeStamp(date, locale, context)}',
                            style: TextStyle(
                                fontSize: widthQuery ? 15 : 13,
                                color: Colors.grey)))),
                if (items.length > 3)
                  ...items
                      .take(3)
                      .map((e) => e.isText
                          ? buildTextField(e.description, widthQuery)
                          : Center(
                              child: buildMediaItem(
                                  e.mediaURL, e.thumbnailURL, widthQuery)))
                      .toList(),
                if (items.length <= 3)
                  ...items
                      .map((e) => e.isText
                          ? buildTextField(e.description, widthQuery)
                          : Center(
                              child: buildMediaItem(
                                  e.mediaURL, e.thumbnailURL, widthQuery)))
                      .toList()
              ]),
        ),
      ),
    );
  }
}
