// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../general.dart';
import '../providers/home_provider.dart';
import '../providers/theme_provider.dart';

class ArticleScreen extends StatefulWidget {
  final dynamic article;
  const ArticleScreen(this.article);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeProvider>(context);
    final theme = Provider.of<ThemeModel>(context);
    final avatarUrl = home.avatarUrl;
    final bio = home.bio;
    final direction = theme.textDirection;
    final langCode = theme.langCode;
    final widthQuery = MediaQuery.of(context).size.width >= 800;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final bioWidget = Expanded(
      child: Text(
        bio,
        // maxLines: 100,
        softWrap: true,
        style: TextStyle(
            color: Colors.black,
            fontSize: widthQuery ? 16.5 : 13.75,
            fontFamily: "Roboto"),
      ),
    );
    final Widget nameAndAvatar = Container(
      height: 135,
      decoration: BoxDecoration(
          border: direction == TextDirection.rtl
              ? Border(left: BorderSide(color: Colors.grey.shade200))
              : Border(right: BorderSide(color: Colors.grey.shade200))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: NetworkImage(avatarUrl)),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                home.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 20 : 15),
              )),
        ],
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                // splashColor: Colors.white,
                hoverColor: Colors.white,
                icon: Icon(Icons.arrow_back,
                    color: secondaryColor, size: widthQuery ? 35 : 25)),
            title: Text(widget.article.title,
                style: TextStyle(
                    color: secondaryColor, fontSize: widthQuery ? 22 : 17))),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: direction == TextDirection.ltr
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            General.timeStamp(
                                widget.article.date, langCode, context),
                            style: TextStyle(
                                fontSize: widthQuery ? 19 : 16,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic)),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.article.title,
                          style: GoogleFonts.kaiseiDecol(
                              textStyle: TextStyle(
                                  fontSize: widthQuery ? 25.5 : 23,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.article.description,
                        style: GoogleFonts.nanumGothic(
                          textStyle: TextStyle(
                              fontSize: widthQuery ? 16 : 15.75,
                              color: Colors.black),
                        )),
                  ),
                  const SizedBox(height: 20),
                  if (widget.article.mediaUrl != '')
                    Container(
                        height: widthQuery ? 500 : 300,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade50),
                  if (widget.article.mediaUrl != '') const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: direction == TextDirection.ltr
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (direction == TextDirection.ltr) nameAndAvatar,
                      if (direction == TextDirection.ltr)
                        const SizedBox(width: 10),
                      if (direction == TextDirection.ltr) bioWidget,
                      if (direction == TextDirection.rtl) bioWidget,
                      if (direction == TextDirection.rtl)
                        const SizedBox(width: 10),
                      if (direction == TextDirection.rtl) nameAndAvatar,
                    ],
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
